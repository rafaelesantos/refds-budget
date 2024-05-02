import SwiftUI
import RefdsUI

public struct LoadingRowView: View {
    @State private var loading: Bool = false
    private let isLoading: Bool
    private let isToolbar: Bool
    
    public init(isLoading: Bool, isToolbar: Bool = false) {
        self.isLoading = isLoading
        self.isToolbar = isToolbar
    }
    
    @ViewBuilder
    public var body: some View {
        Group {
            if loading {
                if isToolbar {
                    RefdsLoadingView()
                } else {
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
