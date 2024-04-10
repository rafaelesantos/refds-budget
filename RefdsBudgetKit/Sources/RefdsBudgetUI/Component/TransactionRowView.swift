import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetPresentation

public struct TransactionRowView: View {
    private let viewData: TransactionRowViewData
    
    public init(viewData: TransactionRowViewData) {
        self.viewData = viewData
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: .padding(.medium)) {
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
            
            VStack(alignment: .leading, spacing: .padding(.extraSmall)) {
                HStack(spacing: .padding(.small)) {
                    RefdsText(viewData.amount.currency(), weight: .bold, lineLimit: 1)
                    Spacer(minLength: .zero)
                    RefdsText(viewData.date.asString(withDateFormat: .custom(" HH : mm ")), style: .callout, color: .secondary)
                }
                
                RefdsText(viewData.description, style: .callout, color: .secondary)
            }
        }
    }
}

#Preview {
    List {
        ForEach((1 ... 5).indices, id: \.self) { _ in
            Section {
                ForEach((1 ... .random(in: 1 ... 3)).indices, id: \.self) { _ in
                    let viewData = TransactionRowViewData(
                        icon: RefdsIconSymbol.random.rawValue,
                        color: .random,
                        amount: .random(in: 1 ... 1000),
                        description: .someParagraph(),
                        date: .current
                    )
                    TransactionRowView(viewData: viewData)
                }
            }
        }
    }
}
