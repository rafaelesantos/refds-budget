import SwiftUI
import RefdsUI

public struct LoadingRowView: View {
    private let isLoading: Bool
    private let isToolbar: Bool
    
    public init(isLoading: Bool, isToolbar: Bool = false) {
        self.isLoading = isLoading
        self.isToolbar = isToolbar
    }
    
    @ViewBuilder
    public var body: some View {
        if isLoading {
            if isToolbar {
                RefdsLoadingView()
            } else {
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

#Preview {
    List {
        LoadingRowView(isLoading: true)
    }
}
