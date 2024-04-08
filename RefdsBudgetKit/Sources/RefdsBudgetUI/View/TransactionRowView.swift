import SwiftUI
import RefdsUI

public struct TransactionRowView: View {
    private let icon: String
    private let color: Color
    private let amount: Double
    private let description: String
    private let date: Date
    
    public init(
        icon: String,
        color: Color,
        amount: Double,
        description: String,
        date: Date
    ) {
        self.icon = icon
        self.color = color
        self.amount = amount
        self.description = description
        self.date = date
    }
    
    public var body: some View {
        HStack(spacing: .padding(.medium)) {
            if let icon = RefdsIconSymbol(rawValue: icon) {
                RefdsIcon(
                    icon,
                    color: color,
                    size: .padding(.medium)
                )
                .frame(width: .padding(.medium), height: .padding(.medium))
                .padding(.padding(.small))
                .background(color.opacity(0.2))
                .clipShape(.rect(cornerRadius: .cornerRadius))
            }
            
            VStack {
                HStack(spacing: .padding(.small)) {
                    RefdsText(amount.currency(), weight: .bold, lineLimit: 1)
                    Spacer(minLength: .zero)
                    RefdsText(date.asString(withDateFormat: .custom("HH:mm")), style: .footnote, color: .secondary)
                }
                
                RefdsText(description, color: .secondary, lineLimit: 2)
            }
        }
    }
}

#Preview {
    List {
        ForEach((1 ... 5).indices, id: \.self) { _ in
            TransactionRowView(
                icon: RefdsIconSymbol.random.rawValue,
                color: .random,
                amount: .random(in: 1 ... 1000),
                description: .someParagraph(),
                date: .current
            )
        }
    }
}
