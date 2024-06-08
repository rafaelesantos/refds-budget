import SwiftUI
import RefdsUI
import RefdsShared

public struct DateRowView: View {
    @Binding private var date: Date
    
    public init(date: Binding<Date>) {
        self._date = date
    }
    
    public var body: some View {
        HStack(spacing: .padding(.medium)) {
            RefdsText(.localizable(by: .filterDate), style: .callout)
            
            if date.asString(withDateFormat: .fullMonthYear) != Date.current.asString(withDateFormat: .fullMonthYear) {
                RefdsButton {
                    withAnimation {
                        date = Date()
                    }
                } label: {
                    RefdsText(
                        .localizable(by: .filterCurrentMonth).uppercased(),
                        style: .footnote,
                        color: .accentColor,
                        weight: .bold
                    )
                    .refdsTag(color: .accentColor)
                }
                .buttonStyle(.plain)
            }
            
            Spacer(minLength: .zero)
            RefdsText(
                date.asString(withDateFormat: .custom("MMMM, yyyy")).capitalized,
                style: .callout,
                color: .secondary
            )
            RefdsIcon(
                .chevronUpChevronDown,
                color: .secondary.opacity(0.5),
                style: .callout
            )
        }
        .overlay{
            DatePicker(selection: $date, displayedComponents: .date) {
                HStack {
                    RefdsText(.localizable(by: .filterDate), style: .callout)
                    Spacer(minLength: .zero)
                }
            }
            .opacity(0.011)
        }
    }
}

#Preview {
    struct ContainerView: View {
        @State private var date: Date = .current
        
        var body: some View {
            DateRowView(date: $date)
        }
    }
    return ContainerView()
}
