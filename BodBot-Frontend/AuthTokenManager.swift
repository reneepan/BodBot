import Foundation
import Security

class AuthTokenManager {
    static let authTokenKey = "com.example.app.authToken"
    static let userIDKey = "com.example.app.userID"
    
    static func isLoggedIn() -> Bool {
            return authTokenKey != ""
    }
    
    static func saveAuthToken(_ token: String, userID: String) {
        // Save the auth token
        saveData(token, forKey: authTokenKey)
        // Save the user ID
        saveData(userID, forKey: userIDKey)
    }
    
    static func loadAuthToken() -> (token: String?, userID: String?) {
        let token = loadData(forKey: authTokenKey)
        let userID = loadData(forKey: userIDKey)
        return (token, userID)
    }
    
    static func deleteAuthToken() {
        deleteData(forKey: authTokenKey)
        deleteData(forKey: userIDKey)
    }
    
    private static func saveData(_ dataString: String, forKey key: String) {
        guard let data = dataString.data(using: .utf8) else {
            print("Failed to convert string to data")
            return
        }
        
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ] as [String: Any]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Failed to save data for key \(key) with status \(status)")
        }
    }
    
    private static func loadData(forKey key: String) -> String? {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String: Any]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess, let data = dataTypeRef as? Data, let result = String(data: data, encoding: .utf8) {
            return result
        } else {
            print("Failed to load data for key \(key) with status \(status)")
            return nil
        }
    }
    
    private static func deleteData(forKey key: String) {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key
        ] as [String: Any]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("Failed to delete data for key \(key) with status \(status)")
        }
    }
}

//// Usage Example:
//// Save auth token and user ID
//AuthTokenManager.saveAuthToken("YourAuthToken", userID: "YourUserID")
//
//// Load auth token and user ID
//let (loadedToken, loadedUserID) = AuthTokenManager.loadAuthToken()
//if let token = loadedToken, let userID = loadedUserID {
//    print("Loaded auth token: \(token)")
//    print("Loaded user ID: \(userID)")
//} else {
//    print("Failed to load auth token or user ID")
//}
//
//// Delete auth token and user ID
//AuthTokenManager.deleteAuthToken()
