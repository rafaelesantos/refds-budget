import SwiftUI
import RefdsUI
import RefdsShared
import RefdsInjection
import RefdsBudgetPresentation

public struct ComparisonAIView: View {
    @RefdsInjection private var intelligence: IntelligenceProtocol
    
    @State private var isLoading = true
    @State private var progressDescription: String?
    private let excludeDate: Date
    private let completion: () -> Void
    
    public init(
        for excludeDate: Date,
        completion: @escaping () -> Void
    ) {
        self.excludeDate = excludeDate
        self.completion = completion
    }
    
    public var body: some View {
        VStack(spacing: .padding(.extraLarge)) {
            Spacer()
            headerView
            progressView
            Spacer()
            Spacer()
        }
        .padding(.padding(.extraLarge))
        .onChange(of: isLoading, completion)
        .task { trainingModels() }
    }
    
    private var headerView: some View {
        VStack(spacing: .padding(.extraLarge)) {
            RefdsIcon(.cpuFill, color: .accentColor, size: 60)
            
            VStack(spacing: .padding(.small)) {
                RefdsText(
                    "Etapas do Treinamento\nInteligência Artificial",
                    style: .title,
                    weight: .bold,
                    alignment: .center
                )
                
                RefdsText(
                    "Nossos modelos estão aprendendo para oferecer previsões cada vez mais precisas e ajudar você a atingir suas metas financeiras.",
                    color: .secondary,
                    alignment: .center
                )
            }
        }
    }
    
    @ViewBuilder
    private var progressView: some View {
        if isLoading {
            VStack(spacing: .padding(.extraLarge)) {
                RefdsLoadingView()
                    .padding(.vertical)
                
                if let progressDescription = progressDescription {
                    RefdsText(
                        progressDescription,
                        color: .secondary
                    )
                }
            }
        }
    }
    
    private func trainingModels() {
        Task(priority: .high) {
            //intelligence.updateDefaultBase()
            intelligence.training(for: .custom, with: excludeDate) { description, model, _ in
                withAnimation { progressDescription = description }
            }
            withAnimation { isLoading = false }
        }
    }
}

#Preview {
    ComparisonAIView(for: .now) {}
}
