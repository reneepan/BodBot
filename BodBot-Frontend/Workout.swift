import Foundation

struct Workout: Identifiable, Codable, Equatable {
    var id: String
    var name: String
    var description: String
    var muscleGroups: String
    var equipment: String
    var type: String
    var level: String

    enum CodingKeys: String, CodingKey {
        case id = "workoutID"
        case name
        case description
        case muscleGroups
        case equipment
        case type
        case level
    }

    static func ==(lhs: Workout, rhs: Workout) -> Bool {
        return lhs.id == rhs.id
    }
}
