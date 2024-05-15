import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetResource
import RefdsBudgetPresentation

public struct SelectMenuRowView: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.isPro) private var isPro
    
    private let header: LocalizableKey
    private let icon: RefdsIconSymbol
    private let title: LocalizableKey
    
    private let data: [String]
    @Binding private var selectedData: Set<String>
    
    public init(
        header: LocalizableKey,
        icon: RefdsIconSymbol,
        title: LocalizableKey,
        data: [String],
        selectedData: Binding<Set<String>>
    ) {
        self.header = header
        self.icon = icon
        self.title = title
        self.data = data
        self._selectedData = selectedData
    }
    
    public var body: some View {
        if isPro {
            Menu {
                menuHeader
                Divider()
                menuOptions
                Divider()
                menuFooter
            } label: {
                menuLabel
            }
        } else {
            menuLabelPremium
        }
    }
    
    private var menuHeader: some View {
        RefdsText(.localizable(by: header))
    }
    
    private var menuOptions: some View {
        ForEach(data, id: \.self) { item in
            RefdsButton {
                if selectedData.contains(item) {
                    selectedData.remove(item)
                } else {
                    selectedData.insert(item)
                }
            } label: {
                HStack {
                    RefdsText(item)
                    if selectedData.contains(item) {
                        RefdsIcon(.checkmark)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var menuFooter: some View {
        if !selectedData.isEmpty {
            RefdsButton {
                selectedData = []
            } label: {
                Label(
                    String.localizable(by: .menuCleanSelections),
                    systemImage: RefdsIconSymbol.clear.rawValue
                )
            }
        }
    }
    
    private var menuLabel: some View {
        HStack(spacing: .padding(.medium)) {
            RefdsText(.localizable(by: title), style: .callout)
            Spacer()
            menuLabelDetail
            RefdsIcon(icon)
        }
    }
    
    private var menuLabelPremium: some View {
        BudgetLabel(
            title: title,
            icon: icon,
            isProFeature: true
        )
    }
    
    private var menuLabelDetail: some View {
        HStack {
            if selectedData.count == 1 {
                RefdsText(selectedData.first ?? "", style: .callout, color: .secondary)
            } else {
                RefdsText(
                    selectedData.count == .zero ? .localizable(by: .transactionsCategorieAllSelected) :
                        selectedData.count.asString, style: .callout, color: .secondary
                )
            }
        }
    }
}


#Preview {
    List {
        SelectMenuRowView(
            header: .transactionsCategoriesFilterHeader,
            icon: .squareStack3dForwardDottedlineFill,
            title: .categoriesNavigationTitle,
            data: (1 ... 5).map { _ in CategoryRowViewDataMock().name },
            selectedData: .constant([])
        )
        .environment(\.isPro, false)
    }
}
