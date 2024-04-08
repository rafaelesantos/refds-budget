import SwiftUI
import RefdsUI
import RefdsBudgetPresentation

public struct CategoryRowView: View {
    private let viewData: CategoryRowViewData
    
    @State private var budget: Double = 0
    @State private var percentage: Double = 0
    
    public init(viewData: CategoryRowViewData) {
        self.viewData = viewData
    }
    
    public var body: some View {
        Section {
            rowCategory
            rowSpend
            rowTransactions
            rowDescription
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                withAnimation { 
                    budget = viewData.budget
                    percentage = viewData.percentage
                }
            }
        }
    }
    
    private var rowCategory: some View {
        HStack(spacing: .padding(.medium)) {
            if let icon = RefdsIconSymbol(rawValue: viewData.icon) {
                RefdsIcon(
                    icon,
                    color: viewData.color,
                    size: .padding(.medium)
                )
                .frame(width: .padding(.medium), height: .padding(.medium))
                .padding(10)
                .background(viewData.color.opacity(0.4))
                .clipShape(.rect(cornerRadius: .cornerRadius))
            }
            
            VStack(spacing: .padding(.extraSmall)) {
                HStack(spacing: .padding(.small)) {
                    RefdsText(viewData.name, weight: .bold, lineLimit: 1)
                    Spacer(minLength: .zero)
                    RefdsText(budget.currency(), lineLimit: 1)
                        .contentTransition(.numericText())
                }
                
                HStack(spacing: .padding(.small)) {
                    ProgressView(value: percentage, total: 1)
                        .scaleEffect(x: 1, y: 1.5, anchor: .center)
                        .tint(viewData.color.opacity(0.2))
                    RefdsText(viewData.percentage.percent(), style: .callout, color: .secondary)
                }
            }
        }
    }
    
    private var rowSpend: some View {
        HStack {
            RefdsText(.localizable(by: .categoryRowSpend), style: .callout)
            Spacer()
            RefdsText(viewData.spend.currency(), style: .callout, color: .secondary)
        }
    }
    
    private var rowTransactions: some View {
        HStack {
            RefdsText(.localizable(by: .categoryRowTransactions), style: .callout)
            Spacer()
            RefdsText(viewData.transactionsAmount.asString, style: .callout, color: .secondary)
        }
    }
    
    @ViewBuilder
    private var rowDescription: some View {
        if let description = viewData.description, !description.isEmpty {
            RefdsText(description, style: .callout, color: .secondary)
        }
    }
}

#Preview {
    List {
        ForEach((1 ... 5).indices, id: \.self) { _ in
            let viewData = CategoryRowViewData(
                icon: RefdsIconSymbol.random.rawValue,
                name: .someWord(),
                description: .someParagraph(),
                color: .random,
                budget: .random(in: 250 ... 1000),
                percentage: .random(in: 0.25 ... 1),
                transactionsAmount: .random(in: 1 ... 100),
                spend: .random(in: 250 ... 1000)
            )
            CategoryRowView(viewData: viewData)
        }
    }
}
