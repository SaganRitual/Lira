// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import Foundation
import SpriteKit

extension Entities {
    
    class MoveHandle:
        Entity,
        Entities.Feature.HasAvatarShape,
        Entities.Feature.Positionable
    {
        override var isHandle: Bool { true }

        let shape: Components.AvatarShape

        var isActive: Bool { !shape.isHidden }

        private var te: SelectableEntity!
        var targetEntity: SelectableEntity { te }

        private var dragAnchor = CGPoint.zero
        private var subscriptions = Set<AnyCancellable>()

        var position: CGPoint {
            get { shape.position }

            set {
                shape.position = newValue

                if var hasPosition = targetEntity as? Entities.Feature.Positionable {
                    hasPosition.position = newValue
                }
            }
        }

        init(_ dragManager: DragManager) {
            self.shape = Components.MoveHandleShape.makeShape()

            super.init()

            self.shape.setOwnerEntity(self)

            dragManager.dragHandlePublisher
                .sink { [weak self] in self?.dispatchDrag($0) }
                .store(in: &subscriptions)
        }

        func activate() {
            shape.show()
        }

        func deactivate() {
            shape.hide()
        }

        func setTargetEntity(_ targetEntity: SelectableEntity) {
            te = targetEntity
        }

        func toggleActivation() {
            shape.toggleVisible()
        }
        
        func dispatchDrag(_ dragInfo: DragInfo) {
            guard isActive else { return }

            let scene = shape.scene! as! SpriteWorld.Scene

            let sv = scene.convertPoint(fromView: dragInfo.startVertex)
            let ev = scene.convertPoint(fromView: dragInfo.endVertex)

            switch dragInfo.phase {
            case .begin:
                dragBegin(sv, ev, dragInfo.control, dragInfo.shift)

            case .continue:
                dragContinue(sv, ev, dragInfo.control, dragInfo.shift)

            case .end:
                dragEnd(sv, ev, dragInfo.control, dragInfo.shift)
                break
            }

        }

        func dragBegin(_ startVertex: CGPoint, _ endVertex: CGPoint, _ control: Bool, _ shift: Bool) {
            dragAnchor = self.position
        }

        func dragContinue(_ startVertex: CGPoint, _ endVertex: CGPoint, _ control: Bool, _ shift: Bool) {
            let delta = endVertex - startVertex
            let newPosition = dragAnchor + delta

            self.position = newPosition
        }

        func dragEnd(_ startVertex: CGPoint, _ endVertex: CGPoint, _ control: Bool, _ shift: Bool) {
        }
    }
}
