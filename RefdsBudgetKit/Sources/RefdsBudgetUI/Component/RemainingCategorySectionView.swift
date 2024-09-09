import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetPresentation

public struct RemainingCategorySectionView<Header: View>: View {
    @Environment(\.isPro) private var isPro
    
    private let header: () -> Header
    private let viewData: [CategoryRowViewDataProtocol]
    private let action: ((CategoryRowViewDataProtocol) -> Void)?
    
    @Binding private var selectedRemaining: CategoryRowViewDataProtocol?
    @State private var budget: Double = .zero
    @State private var percentage: Double = .zero
    
    public init(
        @ViewBuilder header: @escaping () -> Header,
        selectedRemaining: Binding<CategoryRowViewDataProtocol?>,
        viewData: [CategoryRowViewDataProtocol],
        action: ((CategoryRowViewDataProtocol) -> Void)? = nil
    ) {
        self.header = header
        self._selectedRemaining = selectedRemaining
        self.viewData = viewData
        self.action = action
    }
    
    @ViewBuilder
    public var body: some View {
        if !viewData.isEmpty {
            RefdsSection {
                Group {
                    header()
                }
                .budgetSubscription()
            } header: {
                RefdsText(
                    .localizable(by: .homeRemainingHeader),
                    style: .footnote,
                    color: .secondary
                )
            }
            .onAppear { selectedRemaining = nil }
        }
        
        if isPro {
            RefdsSection {
                remainingCategories
            }
            .onAppear { selectedRemaining = nil }
        }
    }
    
    private var remainingCategories: some View {
        ForEach(viewData.indices, id: \.self) {
            let viewData = viewData[$0]
            RefdsButton {
                withAnimation { selectedRemaining = viewData }
            } label: {
                RemainingCategoryRowView(viewData: viewData)
            }
        }
    }
}

#Preview {
    List {
        RemainingCategorySectionView(
            header: { BalanceRowView(viewData: BalanceRowViewDataMock()) },
            selectedRemaining: .constant(nil),
            viewData: (1 ... 3).map { _ in CategoryRowViewDataMock() }
        )
    }
}
