// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SpriteKit

enum ActionTokens {
    class Base {
        let duration: TimeInterval

        init(duration: TimeInterval) {
            self.duration = duration
        }

        func makeAction() -> SKAction { fatalError() }
    }

    final class Move: Base {
        let destination: CGPoint

        init(destination: CGPoint, duration: TimeInterval) {
            self.destination = destination

            super.init(duration: duration)
        }

        override func makeAction() -> SKAction {
            SKAction.move(to: destination, duration: duration)
        }
    }

}
