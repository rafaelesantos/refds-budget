import SwiftUI
import RefdsUI
import Charts
import RefdsShared
import RefdsBudgetPresentation

public struct TagsSectionView: View {
    @Environment(\.privacyMode) private var privacyMode
    @Environment(\.isPro) private var isPro
    
    @State private var selectedTag: TagRowViewDataProtocol?
    @State private var tags: [TagRowViewDataProtocol] = []
    
    private let tagsViewData: [TagRowViewDataProtocol]
    private let action: () -> Void
    
    private var bindingAngleSelection: Binding<Double?> {
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
        self.tagsViewData = tags.filter {
            ($0.value ?? .zero) > .zero
        }.sorted(by: {
            ($0.value ?? .zero) > ($1.value ?? .zero)
        })
        self.action = action
    }
    
    @ViewBuilder
    public var body: some View {
        RefdsSection {
            Group {
                rowManageTagsView
                if tagsViewData.allSatisfy({ $0.value != nil && ($0.value ?? .zero) > .zero }),
                   !tagsViewData.isEmpty {
                    VStack {
                        headerView
                        chartView
                    }
                    .frame(height: 320)
                }
            }
            .budgetSubscription()
        } header: {
            RefdsText(
                .localizable(by: .tagsChartSectionHeader),
                style: .footnote,
                color: .secondary
            )
        }
        .onChange(of: tagsViewData.map { $0.name }) { updateData() }
        .onChange(of: tagsViewData.map { $0.color }) { updateData() }
        .onChange(of: tagsViewData.map { $0.id }) { updateData() }
        .onAppear { reloadData() }
        
        if isPro {
            RefdsSection {
                rowTags
            }
        }
    }
    
    private func reloadData() {
        withAnimation {
            selectedTag = tagsViewData.first
        }
        
        guard tags.isEmpty else { return }
        tags = tagsViewData
        tagsViewData.indices.forEach { index in
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    tags[index].isAnimate = true
                }
            }
        }
    }
    
    private func updateData() {
        tags = []
        reloadData()
    }
    
    @ViewBuilder
    private var headerView: some View {
        if let selectedTag = selectedTag, let value = selectedTag.value {
            VStack {
                RefdsText(value.currency(), style: .title, weight: .bold, lineLimit: 1)
                    .contentTransition(.numericText())
                    .refdsRedacted(if: privacyMode)
                RefdsText(selectedTag.name, style: .callout, color: .secondary, lineLimit: 1)
            }
        }
    }
    
    private var chartView: some View {
        ZStack {
            Chart(tags, id: \.id) {
                SectorMark(
                    angle: .value("y", $0.isAnimate ? ($0.value ?? .zero) : .zero),
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
            .chartAngleSelection(value: bindingAngleSelection)
            .frame(height: 250)
            
            if let selectedTag = selectedTag {
                RefdsIcon(
                    selectedTag.icon,
                    color: selectedTag.color,
                    size: 30
                )
            }
        }
    }
    
    private var rowManageTagsView: some View {
        RefdsButton {
            action()
        } label: {
            HStack(spacing: .padding(.medium)) {
                RefdsIconRow(.tagFill)
                RefdsText(
                    .localizable(by: .homeManageTags),
                    style: .callout
                )
                Spacer()
                RefdsIcon(.chevronRight, color: .secondary.opacity(0.5), style: .callout)
            }
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
                    TagRowView(viewData: tag, isSelected: true)
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
