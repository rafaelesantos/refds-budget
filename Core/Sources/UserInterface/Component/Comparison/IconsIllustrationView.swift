import SwiftUI
import RefdsUI
import RefdsShared

struct IconsIllustrationView: View {
    @State private var icons: [RefdsIconSymbol] = []
    @State var isViewDisplayed = false
    
    private let size: CGFloat
    
    init(size: CGFloat = 100) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .top) {
                    RefdsIconRow(icons[safe: 0] ?? .random, color: .random, size: size * 0.34)
                    RefdsIconRow(icons[safe: 1] ?? .random, color: .random, size: size * 0.46)
                }
                Spacer(minLength: .zero)
            }
            VStack {
                Spacer(minLength: .zero)
                HStack(alignment: .bottom) {
                    RefdsIconRow(icons[safe: 2] ?? .random, color: .random, size: size * 0.46)
                    RefdsIconRow(icons[safe: 3] ?? .random, color: .random, size: size * 0.34)
                }
            }
        }
        .frame(width: size, height: size)
        .onDisappear { isViewDisplayed = false }
        .onAppear {
            isViewDisplayed = true
            reloadData()
        }
    }
    
    private func reloadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                icons = RefdsIconSymbol.categoryIcons.shuffled()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if isViewDisplayed { reloadData() }
            }
        }
    }
}

#Preview {
    IconsIllustrationView()
}
