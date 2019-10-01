import Foundation

extension String {
    static func randomizedString(length: Int) -> String {
        let charactersString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var characters = Array(charactersString)
        var string:String = ""
        for _ in 0 ..< length {
            string.append(characters[Int(arc4random()) % characters.count])
        }
        return string
    }
}
