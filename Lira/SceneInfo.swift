// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation

final class SceneInfo: ObservableObject {
    @Published var hoverLocation: CGPoint?
    @Published var viewSize: CGSize = .zero
}
