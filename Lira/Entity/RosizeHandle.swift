// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import Foundation
import SpriteKit

extension Entities {
    
    final class RosizeHandle:
        Entity,
        Components.Feature.HasAvatarShape
    {

        var shape: SKShapeNode {
            SKShapeNode()
        }

        private var subscriptions = Set<AnyCancellable>()

        init(_ dragManager: DragManager) {
            super.init()

            dragManager.dragHandlePublisher
                .sink { [weak self] in self?.dispatchDrag($0) }
                .store(in: &subscriptions)
        }

        func dispatchDrag(_ dragInfo: DragInfo) {

        }
    }
    
}
