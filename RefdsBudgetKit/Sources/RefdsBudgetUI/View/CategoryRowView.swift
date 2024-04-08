import SwiftUI
import RefdsUI
import RefdsBudgetPresentation

public struct CategoryRowView: View {
    private let icon: String
    private let name: String
    private let color: Color
    private let budget: Double
    private let percentage: Double
    
    public init(
        icon: String,
        name: String,
        color: Color,
        budget: Double,
        percentage: Double
    ) {
        self.icon = icon
        self.name = name
        self.color = color
        self.budget = budget
        self.percentage = percentage
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
            
            VStack(spacing: .padding(.extraSmall)) {
                HStack(spacing: .padding(.small)) {
                    RefdsText(name, weight: .bold, lineLimit: 1)
                    Spacer(minLength: .zero)
                    RefdsText(budget.currency(), lineLimit: 1)
                }
                
                HStack(spacing: .padding(.small)) {
                    ProgressView(value: percentage, total: 1)
                        .scaleEffect(x: 1, y: 1.5, anchor: .center)
                        .tint(color.opacity(0.2))
                    RefdsText(percentage.percent(), style: .footnote, color: .secondary)
                }
            }
        }
    }
}

#Preview {
    List {
        ForEach((1 ... 5).indices, id: \.self) { _ in
            CategoryRowView(
                icon: RefdsIconSymbol.random.rawValue,
                name: .someWord(),
                color: .random,
                budget: .random(in: 250 ... 1000),
                percentage: .random(in: 0.25 ... 1)
            )
        }
    }
}
