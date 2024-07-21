import SwiftUI
import RefdsUI
import RefdsShared

public struct IconsIllustrationView: View {
    
    private let size: CGFloat
    
    public init(size: CGFloat = 100) {
        self.size = size
    }
    
    public var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .top) {
                    RefdsIconRow(.random, color: .random, size: size * 0.34)
                    RefdsIconRow(.random, color: .random, size: size * 0.46)
                }
                Spacer(minLength: .zero)
            }
            VStack {
                Spacer(minLength: .zero)
                HStack(alignment: .bottom) {
                    RefdsIconRow(.random, color: .random, size: size * 0.46)
                    RefdsIconRow(.random, color: .random, size: size * 0.34)
                }
            }
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    IconsIllustrationView()
}
