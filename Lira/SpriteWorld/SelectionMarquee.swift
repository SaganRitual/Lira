// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import Foundation
import SpriteKit

extension SpriteWorld {

    class SelectionMarquee {
        let scene: SpriteWorld.Scene

        let anchorPoints: [SpriteWorld.Directions: CGPoint] = [
            .n: CGPoint(x: 0, y: 0.5),
            .e: CGPoint(x: 0.5, y: 0),
            .s: CGPoint(x: 1, y: 0.5),
            .w: CGPoint(x: 0.5, y: 1)
        ]

        let selectionExtentRoot = SKNode()

        var borderSprites = [SpriteWorld.Directions: SKSpriteNode]()

        init(_ scene: SpriteWorld.Scene) {
            self.scene = scene

            Directions.allCases.forEach { direction in
                let sprite = SKSpriteNode(imageNamed: "pixel_1x1")
                sprite.name = "selectionMarqueeSprite_\(direction)" 

                sprite.alpha = 0.7
                sprite.colorBlendFactor = 1
                sprite.color = .yellow
                sprite.isHidden = false
                sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                sprite.size = CGSize(width: 1, height: 1)

                sprite.anchorPoint = anchorPoints[direction]!

                borderSprites[direction] = sprite

                selectionExtentRoot.addChild(sprite)
            }

            selectionExtentRoot.isHidden = true

            scene.rootNode.addChild(selectionExtentRoot)
        }

        func dispatchDrag(_ dragInfo: DragInfo) {
            let sv = scene.convertPoint(fromView: dragInfo.startVertex)
            let ev = scene.convertPoint(fromView: dragInfo.endVertex)

            switch dragInfo.phase {
            case .end:
                hide()

            default:
                draw(from: sv, to: ev)
            }
        }
    }

}

private extension SpriteWorld.SelectionMarquee {

    func show() { selectionExtentRoot.isHidden = false }
    func hide() { selectionExtentRoot.isHidden = true }

    func draw(from startVertex: CGPoint, to endVertex: CGPoint) {
        // If the user begins dragging and moves the mouse up and to the left, this box size
        // will have negative width and height. Fortunately, that's exactly what we need for
        // scaling the width and height of the rubber band sprites to track perfectly with the mouse
        let boxSize = CGSize(width: endVertex.x - startVertex.x, height: endVertex.y - startVertex.y)

        if boxSize == .zero {
            // In case the user is futzing with the mouse and causes
            // the box size to go back to zero
            hide()
            return
        }

        borderSprites[.n]!.position = endVertex
        borderSprites[.w]!.position = endVertex

        borderSprites[.e]!.position = startVertex
        borderSprites[.s]!.position = startVertex

        // The negative camera scale is an artifact of the way we convert
        // the start/end vertices from the view, I think. Come back to it
        // and make more sense of it at some point
        let hScale = CGSize(width: boxSize.width, height: 2) * -scene.cameraScale

        borderSprites[.n]!.scale(to: hScale)
        borderSprites[.s]!.scale(to: hScale)

        let vScale = CGSize(width: 2, height: boxSize.height) * scene.cameraScale

        borderSprites[.e]!.scale(to: vScale)
        borderSprites[.w]!.scale(to: vScale)

        show()
    }

}
