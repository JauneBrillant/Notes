import SwiftData
import SwiftUI

@Model
class ItemModel {
    @Attribute(.unique) var sentence: String
    @Attribute(.unique) var order: Int
    var notificationTime: Date? = nil
    var notificationDays: [Int] = []
    var isActive: Bool = true

    init(sentence: String, order: Int) {
        self.sentence = sentence
        self.order = order
    }
}
