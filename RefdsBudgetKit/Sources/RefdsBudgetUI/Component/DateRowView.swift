import SwiftUI
import RefdsUI
import RefdsShared

public struct DateRowView<Content: View>: View {
    @Binding private var date: Date
    private var content: () -> Content
    
    public init(date: Binding<Date>, @ViewBuilder content: @escaping () -> Content) {
        self._date = date
        self.content = content
    }
    
    private var bindingMonth: Binding<String> {
        Binding {
            date.asString(withDateFormat: .month)
        } set: {
            if let year = date.asString(withDateFormat: .year).asInt,
               let date = "\($0)/\(year)".asDate(withFormat: .fullMonthYear) {
                self.date = date
            }
        }
    }
    
    private var bindingYear: Binding<Int> {
        Binding {
            date.asString(withDateFormat: .year).asInt ?? .zero
        } set: {
            let month = date.asString(withDateFormat: .month)
            if let date = "\(month)/\($0)".asDate(withFormat: .fullMonthYear) {
                self.date = date
            }
        }
    }
    
    public var body: some View {
        Menu {
            let months = Calendar.current.monthSymbols
            ForEach(months, id: \.self) { month in
                RefdsButton {
                    withAnimation {
                        bindingMonth.wrappedValue = month
                    }
                } label: {
                    Label(
                        month.capitalized,
                        systemImage: bindingMonth.wrappedValue == month ? RefdsIconSymbol.checkmark.rawValue : ""
                    )
                }
            }
        } label: {
            RefdsText(.localizable(by: .filterDateMonth))
        }
        
        Menu {
            let currentYear = date.asString(withDateFormat: .year).asInt ?? .zero
            let years = (currentYear - 8 ... currentYear + 8).map { $0 }
            ForEach(years, id: \.self) { year in
                RefdsButton {
                    withAnimation {
                        bindingYear.wrappedValue = year
                    }
                } label: {
                    Label(
                        year.asString,
                        systemImage: bindingYear.wrappedValue == year ? RefdsIconSymbol.checkmark.rawValue : ""
                    )
                }
            }
        } label: {
            RefdsText(.localizable(by: .filterDateYear))
        }
    }
}

#Preview {
    struct ContainerView: View {
        @State private var date: Date = .current
        
        var body: some View {
            DateRowView(date: $date) {
                RefdsText(.someWord())
            }
        }
    }
    return ContainerView()
}
