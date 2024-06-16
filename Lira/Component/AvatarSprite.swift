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
        static let radius = 25.0

        static func makeShape() -> AvatarShape {
            let shape = AvatarShape(circleOfRadius: radius)

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

    final class RosizeHandleShape: AvatarShape {
        static let radius = 5.0

        static func makeShape() -> AvatarShape {
            let shape = AvatarShape(circleOfRadius: radius)
            
            shape.isAntialiased = true
            shape.strokeColor = .clear
            shape.blendMode = .replace
            shape.isHidden = false
            shape.zPosition = 11

            return shape
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    }
}
