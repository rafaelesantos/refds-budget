import SwiftUI
import RefdsUI

struct FilterView: View {
    
    @State var isFiltered: Bool = true
    
    private var bindingIsFiltered: Binding<Bool> {
        Binding { isFiltered } set: { newValue in
            withAnimation {
                isFiltered = newValue
            }
        }
    }
    
    var body: some View {
        sectionFilterState
        sectionFilters
    }
    
    private var sectionFilterState: some View {
        Section {
            RefdsToggle(isOn: bindingIsFiltered) {
                RefdsText("Aplicar filtro")
            }
        }
    }
    
    @ViewBuilder
    private var sectionFilters: some View {
        if isFiltered {
            Section {} header: {
                RefdsText(
                    "Filtros",
                    style: .footnote,
                    color: .secondary
                )
            } footer: {
                ScrollView(.horizontal) {
                    HStack(spacing: .padding(.medium)) {
                        ForEach((1 ... 4), id: \.self) { _ in
                            RefdsMenu(style: .card, color: .accentColor, icon: .random, text: .someWord(), description: nil, detail: "2", font: .body) {
                                
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .scrollIndicators(.never)
                .padding(.horizontal, -40)
            }
        }
    }
}

#Preview {
    List {
        FilterView()
    }
}
