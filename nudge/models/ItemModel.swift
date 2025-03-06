import SwiftData
import SwiftUI

@Model
class ItemModel {
    @Attribute(.unique) var sentence: String
    @Attribute(.unique) var order: Int

    init(sentence: String, order: Int) {
        self.sentence = sentence
        self.order = order
    }
}
