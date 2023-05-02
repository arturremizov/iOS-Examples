
struct NotificationOptions: OptionSet {
    
    static let daily = NotificationOptions(rawValue: 1)
    static let newContent = NotificationOptions(rawValue: 1 << 1)
    static let weeklyDigest = NotificationOptions(rawValue: 1 << 2)
    static let newFollows = NotificationOptions(rawValue: 1 << 3)
    
    static let all: NotificationOptions = [.daily, .newContent, .weeklyDigest, .newFollows]
    
    let rawValue: Int8
}

class User {
    var notificationPreferences: NotificationOptions = []
}

let user = User()
user.notificationPreferences = [.newContent, .newFollows] // 0b0000010 | 0b0001000 = 0b0001010

user.notificationPreferences.contains(.newContent) // 0b0001010 & 0b0000010 = 0b0000010
user.notificationPreferences.contains(.weeklyDigest) // 0b0001010 & 0b0000100 = 0b0000000

user.notificationPreferences.insert(.weeklyDigest) // 0b0001010 | 0b0000100 = 0b0001110
user.notificationPreferences.contains(.weeklyDigest) // 0b0001110 & 0b0000100 = 0b0000100


let one = 0b0000001
one == 1

// OR
1 | 2 | 4 | 8
0b0000001 | 0b0000010 | 0b0000100 | 0b0001000 == 0b00001111


let left: NotificationOptions = [.weeklyDigest, .newFollows] // 0b00001100
let right: NotificationOptions = [.newContent, .weeklyDigest] // 0b00000110

left.union(right) // 0b00001100 | 0b00000110 = 0b00001110
