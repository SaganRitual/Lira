// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import Foundation
import SpriteKit

extension Entities {
    
    final class RosizeHandle:
        Entity,
        Entities.Feature.HasAvatarShape,
        Entities.Feature.Scalable
    {
        override var isHandle: Bool { true }

        var scale: CGFloat {
            get { sqrt(2 * shape.xScale * shape.xScale) }

            set {
                shape.setScale(newValue)
            }
        }

        let direction: SpriteWorld.Directions
        let shape: Components.AvatarShape

        init(_ direction: SpriteWorld.Directions, _ parentRadius: CGFloat) {
            self.direction = direction
            self.shape = Components.RosizeHandleShape.makeShape()

            super.init()

            self.shape.setOwnerEntity(self)

            deploy(direction, parentRadius)
        }

    }
    
}

private extension Entities.RosizeHandle {

    func deploy(_ direction: SpriteWorld.Directions, _ parentRadius: CGFloat) {
        switch direction {
        case .n:
            shape.fillColor = .red
            shape.position = CGPoint(x: 0, y: parentRadius)
        case .e:
            shape.fillColor = .green
            shape.position = CGPoint(x: parentRadius, y: 0)
        case .s:
            shape.fillColor = .blue
            shape.position = CGPoint(x: 0, y: -parentRadius)
        case .w:
            shape.fillColor = .yellow
            shape.position = CGPoint(x: -parentRadius, y: 0)
        }
    }

}
