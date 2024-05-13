import SwiftUI
import RefdsUI
import Charts
import RefdsShared
import RefdsBudgetPresentation

public struct TagsSectionView: View {
    @Environment(\.privacyMode) private var privacyMode
    @State private var selectedTag: TagRowViewDataProtocol?
    private let tags: [TagRowViewDataProtocol]
    
    private let action: () -> Void
    
    private var bindindAngleSelection: Binding<Double?> {
        Binding {
            selectedTag?.value
        } set: { value in
            if let value = value, let tag = selectedTag(for: value) {
                withAnimation {
                    selectedTag = tag
                }
            }
        }
    }
    
    private func selectedTag(for value: Double) -> TagRowViewDataProtocol? {
        var total: Double = .zero
        for tag in tags {
            total += tag.value ?? .zero
            if value <= total { return tag }
        }
        
        return tags.last
    }
    
    public init(
        tags: [TagRowViewDataProtocol],
        action: @escaping () -> Void
    ) {
        self.tags = tags.filter {
            ($0.value ?? .zero) > .zero
        }.sorted(by: {
            ($0.value ?? .zero) > ($1.value ?? .zero)
        })
        self.action = action
    }
    
    @ViewBuilder
    public var body: some View {
        if tags.allSatisfy({ $0.value != nil && ($0.value ?? .zero) > .zero }), !tags.isEmpty {
            RefdsSection {
                rowManageTagsView
                VStack {
                    headerView
                    chartView
                }
                .padding(.padding(.extraLarge))
                rowCollapsedView
            } header: {
                RefdsText(
                    .localizable(by: .tagsChartSectionHeader),
                    style: .footnote,
                    color: .secondary
                )
            }
            .onChange(of: tags.count) { selectedTag = tags.first }
            .onAppear { selectedTag = tags.first }
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        if let selectedTag = selectedTag, let value = selectedTag.value {
            VStack {
                RefdsText(value.currency(), style: .title, weight: .bold)
                    .contentTransition(.numericText())
                    .refdsRedacted(if: privacyMode)
                RefdsText(selectedTag.name, style: .callout, color: .secondary)
            }
        }
    }
    
    private var chartView: some View {
        Chart(tags, id: \.id) {
            SectorMark(
                angle: .value("y", $0.value ?? .zero),
                innerRadius: .ratio(selectedTag?.id == $0.id ? 0.4 : 0.5),
                outerRadius: .ratio(selectedTag?.id == $0.id ? 1 : 0.9),
                angularInset: 3
            )
            .cornerRadius(5)
            .foregroundStyle(by: .value("x", $0.name))
            .opacity(selectedTag?.id == $0.id ? 1 : 0.8)
        }
        .chartForegroundStyleScale(
            domain: tags.map  { $0.name },
            range: tags.map { $0.color }
        )
        .chartLegend(.hidden)
        .chartAngleSelection(value: bindindAngleSelection)
        .frame(height: 250)
    }
    
    private var rowManageTagsView: some View {
        RefdsButton {
            action()
        } label: {
            HStack {
                RefdsText(
                    .localizable(by: .homeManageTags),
                    style: .callout
                )
                Spacer()
                RefdsIcon(.chevronRight, color: .secondary.opacity(0.5), style: .callout)
            }
        }
    }
    
    private var rowCollapsedView: some View {
        RefdsCollapse(isCollapsed: false) {
            RefdsText(.localizable(by: .tagsCollapsedHeader), style: .callout)
        } content: {
            rowTags
        }
    }
    
    @ViewBuilder
    private var rowTags: some View {
        if !tags.isEmpty {
            let tags = tags.sorted(by: { ($0.value ?? .zero) > ($1.value ?? .zero) })
            ForEach(tags.indices, id: \.self) {
                let tag = tags[$0]
                RefdsButton {
                    withAnimation { selectedTag = tag }
                } label: {
                    TagRowView(viewData: tag)
                }
            }
        }
    }
}

#Preview {
    List {
        TagsSectionView(
            tags: (1 ... 5).map { _ in TagRowViewDataMock() }
        ) {  }
    }
}
