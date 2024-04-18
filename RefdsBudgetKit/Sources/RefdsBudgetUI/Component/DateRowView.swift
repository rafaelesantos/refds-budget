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
        HStack(spacing: .zero) {
            Picker(selection: bindingMonth) {
                let months = Calendar.current.monthSymbols
                ForEach(months, id: \.self) {
                    RefdsText($0.capitalized)
                        .tag($0)
                }
            } label: {
                content()
            }
            
            Picker(selection: bindingYear) {
                let currentYear = date.asString(withDateFormat: .year).asInt ?? .zero
                let years = (currentYear - 8 ... currentYear + 8).map { $0 }
                ForEach(years, id: \.self) {
                    RefdsText($0.asString)
                        .tag($0)
                }
            } label: {}
                .frame(width: 90)
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
