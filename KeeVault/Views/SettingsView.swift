import SwiftUI

struct SettingsView: View {
    @Bindable var viewModel: DatabaseViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var autoLockTimeout = SettingsService.autoLockTimeout
    @State private var clipboardTimeout = SettingsService.clipboardTimeout

    var body: some View {
        NavigationStack {
            Form {
                Section("Security") {
                    Picker("Auto-Lock Timeout", selection: $autoLockTimeout) {
                        ForEach(SettingsService.AutoLockTimeout.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }

                    Picker("Clipboard Clear Timeout", selection: $clipboardTimeout) {
                        ForEach(SettingsService.ClipboardTimeout.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                }

                Section("Display") {
                    Picker("Default Sort Order", selection: $viewModel.sortOrder) {
                        ForEach(DatabaseViewModel.SortOrder.allCases, id: \.self) { order in
                            Text(order.rawValue).tag(order)
                        }
                    }
                }

                Section("About") {
                    LabeledContent("App", value: "KeeVault")

                    LabeledContent("Version", value: appVersion)

                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .onChange(of: autoLockTimeout) { _, newValue in
                SettingsService.autoLockTimeout = newValue
            }
            .onChange(of: clipboardTimeout) { _, newValue in
                SettingsService.clipboardTimeout = newValue
            }
        }
    }

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "–"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "–"
        return "\(version) (\(build))"
    }
}
