// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import Foundation
import SpriteKit

extension Entities {
    
    final class MoveHandle:
        Entity,
        Entities.Feature.HasAvatarShape
    {

        let shape: SKShapeNode

        var isActive: Bool { !shape.isHidden }

        private var te: SelectableEntity!
        var targetEntity: SelectableEntity { te }

        private var dragAnchor = CGPoint.zero
        private var subscriptions = Set<AnyCancellable>()

        var position: CGPoint {
            get { shape.position }

            set {
                shape.position = newValue

                if var hasPosition = targetEntity as? Entities.Feature.HasPosition {
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

    }
    
}

private extension Entities.MoveHandle {

    func dispatchDrag(_ dragInfo: DragInfo) {
        guard isActive else { return }

        let scene = shape.scene! as! SpriteWorld.Scene

        switch dragInfo.phase {
        case .begin:
            let sv = scene.convertPoint(fromView: dragInfo.startVertex)
            let ev = scene.convertPoint(fromView: dragInfo.endVertex)
            dragBegin(sv, ev, dragInfo.control, dragInfo.shift)

        case .continue:
            let sv = scene.convertPoint(fromView: dragInfo.startVertex)
            let ev = scene.convertPoint(fromView: dragInfo.endVertex)
            dragContinue(sv, ev, dragInfo.control, dragInfo.shift)

        case .end:
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
}
