import StoreKit
import SwiftUI

struct TipJarView: View {
    private var store: StoreKitManager { StoreKitManager.shared }
    @State private var showThankYou = false

    @State private var loadingDone = false

    var body: some View {
        Section {
            if store.tips.isEmpty && !loadingDone {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else if store.tips.isEmpty {
                Text("Tip Jar is not available right now.")
                    .foregroundStyle(.secondary)
                    .font(.callout)
            } else {
                ForEach(store.tips, id: \.id) { product in
                    Button {
                        Task { await store.purchase(product) }
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(product.displayName)
                                    .foregroundStyle(.primary)
                                Text(product.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(product.displayPrice)
                                .font(.callout.bold())
                                .foregroundStyle(.blue)
                        }
                    }
                    .disabled(store.isPurchasing)
                }
            }
        } header: {
            Text("Tip Jar")
        } footer: {
            Text("KeeForge is free and open source. Tips help support development. ❤️")
        }
        .task {
            await store.loadProducts()
            loadingDone = true
        }
        .onChange(of: store.purchaseResult) { _, result in
            if case .success = result {
                showThankYou = true
            }
        }
        .alert("Thank You! 🎉", isPresented: $showThankYou) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your support means the world. Thank you for helping keep KeeForge alive!")
        }
    }
}
