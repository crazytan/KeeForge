import UIKit

enum ClipboardService {
    static func copy(_ string: String) {
        if let seconds = SettingsService.clipboardTimeout.seconds {
            UIPasteboard.general.setItems(
                [[UIPasteboard.typeAutomatic: string]],
                options: [.expirationDate: Date().addingTimeInterval(seconds)]
            )
        } else {
            UIPasteboard.general.string = string
        }
    }
}
