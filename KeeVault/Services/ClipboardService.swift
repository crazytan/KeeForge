import UIKit

enum ClipboardService {
    private static let clearDelay: TimeInterval = 30

    static func copy(_ string: String) {
        UIPasteboard.general.setItems(
            [[UIPasteboard.typeAutomatic: string]],
            options: [.expirationDate: Date().addingTimeInterval(clearDelay)]
        )
    }
}
