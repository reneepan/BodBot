package final_project;

import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.personalize.AmazonPersonalize;
import com.amazonaws.services.personalize.AmazonPersonalizeClientBuilder;
import com.amazonaws.services.personalize.model.CreateDatasetImportJobRequest;
import com.amazonaws.services.personalize.model.DataSource;
import com.amazonaws.services.personalize.model.DatasetImportJobSummary;
import com.amazonaws.services.personalize.model.ListDatasetImportJobsRequest;
import com.amazonaws.services.personalize.model.ListDatasetImportJobsResult;
import com.amazonaws.services.personalizeruntime.AmazonPersonalizeRuntime;
import com.amazonaws.services.personalizeruntime.AmazonPersonalizeRuntimeClientBuilder;
import com.amazonaws.services.personalizeruntime.model.GetRecommendationsRequest;
import com.amazonaws.services.personalizeruntime.model.GetRecommendationsResult;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

public class AWSRecommendationClient {

    private static final String CAMPAIGN_ARN = "arn:aws:personalize:us-east-2:730335253076:campaign/botbot-campaign";
    private AmazonPersonalizeRuntime personalizeRuntimeClient;
    private AmazonS3 s3Client;
    private AmazonPersonalize personalizeClient;

    public AWSRecommendationClient() {
        BasicAWSCredentials awsCreds = new BasicAWSCredentials("AKIA2UC27SJKNO3B2QED", "sY0jpJToBIDep0HJ1uSNRa+/0Z2drM0YQkWzf/xz");
        this.personalizeRuntimeClient = AmazonPersonalizeRuntimeClientBuilder.standard()
        .withRegion("us-east-2").withCredentials(new AWSStaticCredentialsProvider(awsCreds)).build();
        this.s3Client = AmazonS3ClientBuilder.standard().withRegion("us-east-2").withCredentials(new 
        AWSStaticCredentialsProvider(awsCreds)).build();
        this.personalizeClient = AmazonPersonalizeClientBuilder.standard()
        .withRegion("us-east-2").withCredentials(new AWSStaticCredentialsProvider(awsCreds)).build();
    }

    public List<String> getRecommendationList(int userId) {
        List<String> recommendations = new ArrayList<>();
        GetRecommendationsRequest request = new GetRecommendationsRequest()
        .withCampaignArn(CAMPAIGN_ARN).withUserId(String.valueOf(userId));
        request.setNumResults(25);
        try {
            GetRecommendationsResult result = personalizeRuntimeClient.getRecommendations(request);
            result.getItemList().forEach(item -> recommendations.add(item.getItemId()));
        } 
        catch (Exception e) {
            System.out.println("Error getting recommendations: " + e.getMessage());
            e.printStackTrace();
        }
        return recommendations;
    }
    
    public void addInteractionToS3(int userID, int itemID) {
    	long timestamp = System.currentTimeMillis();
    	if (itemID <= 25) {
    		long randInt = 1_000_000_000_000L + (long) (new java.util.Random().nextDouble() * 9_000_000_000_000L);
        	String interactionData = userID + "," + itemID + "," + randInt + ",click";
        	String bucketName = "bodbotbucket";
        	String objectKey = "interactions.csv";
            try {
                InputStream existingContent = s3Client.getObject(bucketName, objectKey).getObjectContent();
                String newContent = new java.util.Scanner(existingContent).useDelimiter("\\A").next() + "\n" + interactionData;
                existingContent.close();
                InputStream newContentStream = new ByteArrayInputStream(newContent.getBytes(StandardCharsets.UTF_8));
                ObjectMetadata metadata = new ObjectMetadata();
                metadata.setContentLength(newContent.length());
                s3Client.putObject(new PutObjectRequest(bucketName, objectKey, newContentStream, metadata));
                System.out.println("Interaction added to S3 successfully.");
                updatePersonalizeDataset(bucketName, objectKey);
            } 
            catch (Exception e) {
                System.out.println("Error updating interactions file in S3: " + e.getMessage());
                e.printStackTrace();
            }
    	}
    }
    
    private void updatePersonalizeDataset(String bucketName, String objectKey) {
    	String datasetArn = "arn:aws:personalize:us-east-2:730335253076:dataset/bodbotdsg/INTERACTIONS";
    	if (hasActiveImportJobs(datasetArn)) {
            System.out.println("Import job is already in progress.");
            return;
        }
        String roleArn = "arn:aws:iam::730335253076:role/AWSPersonalizeRole";
        CreateDatasetImportJobRequest request = new CreateDatasetImportJobRequest().withJobName("DataImportJob-" + System.currentTimeMillis())
        .withDatasetArn(datasetArn).withDataSource(new DataSource().withDataLocation("s3://" + bucketName + "/" + objectKey)).withRoleArn(roleArn);
        personalizeClient.createDatasetImportJob(request);
        System.out.println("Import job started.");
    }
    
    private boolean hasActiveImportJobs(String datasetArn) {
        ListDatasetImportJobsRequest request = new ListDatasetImportJobsRequest().withDatasetArn(datasetArn);
        ListDatasetImportJobsResult response = personalizeClient.listDatasetImportJobs(request);
        List<DatasetImportJobSummary> jobs = response.getDatasetImportJobs();
        return jobs.stream().anyMatch(job -> "CREATE PENDING".equals(job.getStatus()) || "CREATE IN_PROGRESS".equals(job.getStatus()));
    }

    public void shutdown() {
        if (personalizeRuntimeClient != null) {
            personalizeRuntimeClient.shutdown();
        }
    }
}

// HOW TO EXECUTE THIS CODE:

// First make an intance of an AWSRecommendationClient:
// AWSRecommendationClient client = new AWSRecommendationClient();

// If you wanna get a recomedation list for a specific user, do it like this (returns a List<String>)
// client.getRecommendationList(user_ID);

// When a user adds a workout, make sure to add it to the personalization database!
// client.addInteractionToS3(user_ID, workout_ID);