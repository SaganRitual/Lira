// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SpriteKit

extension SpriteWorld {

    final class Game {
        let dragManager: DragManager
        let scene: Scene

        init(_ dragManager: DragManager, _ scene: Scene) {
            self.dragManager = dragManager
            self.scene = scene
        }

        func getOwnerEntity(for node: SKNode) -> Entity? { nil }

        func newEntity(_ tapInfo: TapInfo) -> Entity {
            let sp = tapInfo.positionInScene

            let gremlin = Entities.Gremlin.makeGremlin(at: sp, parentSceneNode: scene.rootNode, dragManager: dragManager)
            return gremlin
        }

    }

}
