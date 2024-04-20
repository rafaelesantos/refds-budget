import SwiftUI
import RefdsUI
import Charts
import RefdsShared
import RefdsBudgetPresentation

public struct TagsSectionView: View {
    private let tags: [TagRowViewDataProtocol]
    @Binding private var selectedTag: TagRowViewDataProtocol
    private let action: (TagAction) -> Void
    
    private var bindindAngleSelection: Binding<Double?> {
        Binding {
            selectedTag.value
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
        selectedTag: Binding<TagRowViewDataProtocol>,
        action: @escaping (TagAction) -> Void
    ) {
        self.tags = tags
        self._selectedTag = selectedTag
        self.action = action
    }
    
    @ViewBuilder
    public var body: some View {
        if tags.allSatisfy({ $0.value != nil }), !tags.isEmpty {
            RefdsSection {
                VStack {
                    headerView
                    chartView
                }
                .padding()
                
                rowCollapsedView
            } header: {
                RefdsText(
                    .localizable(by: .tagsChartSectionHeader),
                    style: .footnote,
                    color: .secondary
                )
            }
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        if let value = selectedTag.value {
            VStack {
                RefdsText(value.currency(), style: .title, weight: .bold)
                    .contentTransition(.numericText())
                RefdsText(selectedTag.name, style: .callout, color: .secondary)
            }
        }
    }
    
    private var chartView: some View {
        Chart(tags, id: \.id) {
            SectorMark(
                angle: .value("y", $0.value ?? .zero),
                innerRadius: .ratio(selectedTag.id == $0.id ? 0.4 : 0.5),
                outerRadius: .ratio(selectedTag.id == $0.id ? 1 : 0.9),
                angularInset: 3
            )
            .cornerRadius(5)
            .foregroundStyle(by: .value("x", $0.name))
            .opacity(selectedTag.id == $0.id ? 1 : 0.8)
        }
        .chartForegroundStyleScale(
            domain: tags.map  { $0.name },
            range: tags.map { $0.color }
        )
        .chartLegend(position: .bottom, alignment: .bottom)
        .chartAngleSelection(value: bindindAngleSelection)
        .frame(height: 320)
    }
    
    private var rowCollapsedView: some View {
        RefdsCollapse(isCollapsed: true) {
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
                TagRowView(viewData: tag) { tag in
                    withAnimation { selectedTag = tag }
                } remove: {
                    action(.removeTag($0.id))
                }
            }
        }
    }
}

#Preview {
    TagsSectionView(
        tags: (1 ... 5).map { _ in TagRowViewDataMock() },
        selectedTag: .constant(TagRowViewData())
    ) { _ in }
}
