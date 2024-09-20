import SwiftUI
import RefdsUI
import RefdsShared
import Mock
import Domain
import Presentation

struct TransactionItemView: View {
    @Environment(\.privacyMode) private var privacyMode
    private let viewData: TransactionItemViewDataProtocol
    
    init(viewData: TransactionItemViewDataProtocol) {
        self.viewData = viewData
    }
    
    var body: some View {
        HStack(spacing: .padding(.medium)) {
            iconWithStatusView
            HStack {
                contentView
                Spacer()
                RefdsIcon(
                    .chevronRight,
                    color: .secondary.opacity(0.5),
                    style: .callout
                )
            }
        }
    }
    
    @ViewBuilder
    private var iconWithStatusView: some View {
        if let icon = RefdsIconSymbol(rawValue: viewData.icon) {
            ZStack(alignment: .bottomTrailing) {
                RefdsIcon(
                    icon,
                    color: viewData.color,
                    size: .padding(.medium)
                )
                .frame(width: .padding(.medium), height: .padding(.medium))
                .padding(10)
                .background(viewData.color.opacity(0.2))
                .clipShape(.rect(cornerRadius: .cornerRadius))
                
                if let icon = viewData.status.icon {
                    RefdsIcon(
                        icon,
                        color: viewData.status.color,
                        size: .padding(.medium)
                    )
                    .padding(-8)
                    .background()
                }
            }
        }
    }
    
    private var contentView: some View {
        VStack(alignment: .leading) {
            HStack(spacing: .padding(.small)) {
                RefdsText(
                    viewData.amount.currency(),
                    style: .callout,
                    color: viewData.status.color,
                    weight: .semibold,
                    lineLimit: 1
                )
                .refdsRedacted(if: privacyMode)
                Spacer(minLength: .zero)
                RefdsText(
                    viewData.date.asString(withDateFormat: .custom("HH:mm")),
                    style: .callout,
                    color: .secondary,
                    weight: .light
                )
            }
            RefdsText(
                viewData.description,
                style: .callout,
                color: .secondary
            )
        }
    }
}

#Preview {
    TransactionItemView(viewData: TransactionItemViewDataMock())
        .refdsCard()
        .padding()
}
