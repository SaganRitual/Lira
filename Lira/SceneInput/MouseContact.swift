// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SpriteKit

extension SceneInputManager {

    struct MouseContact {
        let viewStart: CGPoint
        let viewEnd: CGPoint

        let sceneStart: CGPoint
        let sceneEnd: CGPoint

        let control: Bool
        let shift: Bool

        let getTopNode: ((_ at: CGPoint) -> SKNode?)?

        init(
            viewStart: CGPoint = .zero,
            viewEnd: CGPoint = .zero,
            sceneStart: CGPoint = .zero,
            sceneEnd: CGPoint = .zero,
            control: Bool = false,
            shift: Bool = false,
            getTopNode: @escaping (_: CGPoint) -> SKNode? = { _ in nil }
        ) {
            self.viewStart = viewStart
            self.viewEnd = viewEnd
            self.sceneStart = sceneStart
            self.sceneEnd = sceneEnd
            self.control = control
            self.shift = shift
            self.getTopNode = getTopNode
        }
    }

}

