import SwiftUI
import RefdsUI

public struct LoadingRowView: View {
    private let isLoading: Bool
    
    public init(isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    @ViewBuilder
    public var body: some View {
        if isLoading {
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

#Preview {
    List {
        LoadingRowView(isLoading: true)
    }
}
