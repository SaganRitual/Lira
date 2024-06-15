// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SpriteKit

extension Components {

    final class AvatarSprite: SKSpriteNode {
        init(_ textureName: String, _ position: CGPoint) {
            let texture = SKTexture(imageNamed: textureName)
            super.init(texture: texture, color: .clear, size: texture.size())

            self.position = position
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

}

extension Components {

    class AvatarShape: SKShapeNode {

    }

    final class MoveHandleShape: AvatarShape {
        static func makeShape() -> SKShapeNode {
            let shape = SKShapeNode(circleOfRadius: 15)

            shape.lineWidth = 1
            shape.strokeColor = .green
            shape.fillColor = .clear
            shape.blendMode = .replace
            shape.isHidden = true
            shape.name = "MoveHandleShape"

            return shape
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
