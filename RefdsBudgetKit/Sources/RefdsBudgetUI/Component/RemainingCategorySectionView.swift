import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetPresentation

public struct RemainingCategorySectionView<Header: View>: View {
    private let header: () -> Header
    private let viewData: [CategoryRowViewDataProtocol]
    private let action: ((CategoryRowViewDataProtocol) -> Void)?
    
    @State private var budget: Double = .zero
    @State private var percentage: Double = .zero
    
    public init(
        @ViewBuilder header: @escaping () -> Header,
        viewData: [CategoryRowViewDataProtocol],
        action: ((CategoryRowViewDataProtocol) -> Void)? = nil
    ) {
        self.header = header
        self.viewData = viewData
        self.action = action
    }
    
    public var body: some View {
        RefdsSection {
            header()
            collapseRemainingCategories
        } header: {
            RefdsText(
                .localizable(by: .homeRemainingHeader),
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    private var collapseRemainingCategories: some View {
        RefdsCollapse(isCollapsed: false) {
            RefdsText(.localizable(by: .categoriesNavigationTitle), style: .callout)
        } content: {
            remainingCategories
        }
    }
    
    private var remainingCategories: some View {
        ForEach(viewData.indices, id: \.self) {
            let viewData = viewData[$0]
            RemainingCategoryRowView(viewData: viewData)
        }
    }
}

#Preview {
    List {
        RemainingCategorySectionView(header: {
            BalanceRowView(viewData: BalanceRowViewDataMock())
        }, viewData: (1 ... 3).map { _ in CategoryRowViewDataMock() })
    }
}
