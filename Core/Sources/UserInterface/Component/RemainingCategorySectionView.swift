import SwiftUI
import RefdsUI
import RefdsShared
import Mock
import Domain
import Presentation

public struct RemainingCategorySectionView<Header: View>: View {
    private let header: () -> Header
    private let viewData: [CategoryItemViewDataProtocol]
    private let action: ((CategoryItemViewDataProtocol) -> Void)?
    
    @Binding private var selectedRemaining: CategoryItemViewDataProtocol?
    @State private var budget: Double = .zero
    @State private var percentage: Double = .zero
    
    public init(
        @ViewBuilder header: @escaping () -> Header,
        selectedRemaining: Binding<CategoryItemViewDataProtocol?>,
        viewData: [CategoryItemViewDataProtocol],
        action: ((CategoryItemViewDataProtocol) -> Void)? = nil
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
            } header: {
                RefdsText(
                    .localizable(by: .homeRemainingHeader),
                    style: .footnote,
                    color: .secondary
                )
            }
            .onAppear { selectedRemaining = nil }
        }
        
        RefdsSection {
            remainingCategories
        }
        .onAppear { selectedRemaining = nil }
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
            header: { BalanceView(viewData: BalanceViewDataMock()) },
            selectedRemaining: .constant(nil),
            viewData: (1 ... 3).map { _ in CategoryItemViewDataMock() }
        )
    }
}
