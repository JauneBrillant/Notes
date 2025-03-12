import SwiftData
import SwiftUI

@Model
class ItemModel: Identifiable, Hashable {
    @Attribute(.unique) var sentence: String
    @Attribute(.unique) var order: Int
    var cnt: Int
    var nextReviewDate: Date
    var createdAt: Date

    init(sentence: String, order: Int) {
        self.sentence = sentence
        self.order = order
        self.cnt = 0
        self.nextReviewDate = Calendar.current.date(
            byAdding: .day, value: 1, to: Date())!
        self.createdAt = Date()
    }

    static func == (lhs: ItemModel, rhs: ItemModel) -> Bool {
        return lhs.order == rhs.order
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(order)
    }

    func calculateNextReviewDate() {
        let now = Date()
        let multiplier: Double = pow(2.0, Double(cnt))

        let timeInterval = 24 * 60 * 60 * multiplier
        nextReviewDate = now.addingTimeInterval(timeInterval)
    }
}
