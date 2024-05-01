import SwiftUI
import RefdsUI

public struct LoadingRowView: View {
    @State private var loading: Bool = false
    private let isLoading: Bool
    
    public init(isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    @ViewBuilder
    public var body: some View {
        Group {
            if loading {
                RefdsSection {
                    HStack(spacing: .padding(.extraLarge)) {
                        VStack(alignment: .leading, spacing: .padding(.extraSmall)) {
                            RefdsText(.localizable(by: .loadinginRowTitle), style: .callout, weight: .bold)
                            RefdsText(.localizable(by: .loadinginRowDescription), style: .callout, color: .secondary)
                        }
                        Spacer()
                        RefdsLoadingView()
                    }
                }
            }
        }
        .onAppear { reload() }
        .onChange(of: isLoading) { reload() }
    }
    
    private func reload() {
        withAnimation { loading = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation { self.loading = self.isLoading }
        }
    }
}

#Preview {
    List {
        LoadingRowView(isLoading: true)
    }
}
