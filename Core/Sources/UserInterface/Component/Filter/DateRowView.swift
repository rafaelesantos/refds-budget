import SwiftUI
import RefdsUI
import RefdsShared

public struct DateRowView: View {
    @Binding private var date: Date
    @State private var isPresentedDate = false
    
    public init(date: Binding<Date>) {
        self._date = date
    }
    
    public var body: some View {
        RefdsButton {
            withAnimation { isPresentedDate = true }
        } label: {
            contentView
        }
    }
    
    private var contentView: some View {
        HStack {
            RefdsText(.localizable(by: .filterDate), style: .callout)
            
            Spacer(minLength: .zero)
            
            RefdsText(
                date.asString(withDateFormat: .custom("MMMM, yyyy")).capitalized,
                style: .callout,
                color: .secondary
            )
            .popover(isPresented: $isPresentedDate) {
                RefdsMonthYearPickerView(
                    date: $date,
                    color: Color(hex: Color.accentColor.asHex)
                )
                .presentationCompactAdaptation(.popover)
            }
            
            RefdsIcon(
                .chevronUpChevronDown,
                color: .secondary.opacity(0.5),
                style: .callout
            )
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
