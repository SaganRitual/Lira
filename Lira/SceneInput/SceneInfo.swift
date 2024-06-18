// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation

final class SceneInfo: ObservableObject {
    @Published var hoverLocation: CGPoint?
    @Published var viewSize: CGSize = .zero

    // Convert from SwiftUI View coordinate space to Rob's junior high
    // coordinate space, where the origin is in the center and the y-axis
    // is positive up
    func convertPoint(_ positionInSwiftUIView: CGPoint) -> CGPoint {
        viewSize == .zero
            ? .zero
            : CGPoint(
                x: positionInSwiftUIView.x - viewSize.width / 2,
                y: viewSize.height / 2 - positionInSwiftUIView.y
            )
    }
}
