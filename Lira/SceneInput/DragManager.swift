// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import Foundation
import SpriteKit

final class DragManager {

    let dragHandlePublisher = PassthroughSubject<DragInfo, Never>()
    let scene: SpriteWorld.Scene
    let selectionController: SelectionController
    let selectionMarquee: SpriteWorld.SelectionMarquee

    enum State {
        case dragBackground, dragHandle, idle
    }

    var currentState = State.idle
    var hotDragHandle: Entities.MoveHandle?

    init(
        _ scene: SpriteWorld.Scene,
        _ selectionController: SelectionController,
        _ selectionMarquee: SpriteWorld.SelectionMarquee
    ) {
        self.scene = scene
        self.selectionController = selectionController
        self.selectionMarquee = selectionMarquee
    }

    func drag(startVertex: CGPoint, endVertex: CGPoint, _ control: Bool, _ shift: Bool) {
        if currentState == .idle {
            dragBegin(startVertex, endVertex, control, shift)
        }

        let dragInfo = DragInfo.continue(hotDragHandle, startVertex, endVertex, control, shift)

        switch currentState {
        case .dragBackground:
            selectionMarquee.dispatchDrag(dragInfo)
        case .dragHandle:
            dragHandlePublisher.send(dragInfo)
        default:
            assert(false, "Reputable scientists have said this cannot occur")
        }
    }

    func dragEnd(startVertex: CGPoint, endVertex: CGPoint, _ control: Bool, _ shift: Bool) {
        let dragInfo = DragInfo.end(hotDragHandle, startVertex, endVertex, control, shift)

        switch currentState {
        case .dragBackground:
            selectionController.dispatchDrag(dragInfo)
            selectionMarquee.dispatchDrag(dragInfo)
        case .dragHandle:
            dragHandlePublisher.send(dragInfo)
        default:
            assert(false, "Reputable scientists have said this cannot occur")
        }

        currentState = .idle
        hotDragHandle = nil
    }

}

private extension DragManager {

    // Remember: the selection controller needs to know about drag-entity-begin -- because that might
    // require the entity to be selected -- and drag-background-end -- because that's how you select
    // things with a selection marquee: by letting go of the mouse button

    func dragBegin(_ startVertex: CGPoint, _ endVertex: CGPoint, _ control: Bool, _ shift: Bool) {
        let sv = scene.convertPoint(fromView: startVertex)

        guard let topNode = scene.getTopNode(at: sv) else {
            selectionController.dispatchDrag(DragInfo.begin(nil, startVertex, endVertex, control, shift))
            currentState = .dragBackground
            return
        }

        guard let entity = topNode.getOwnerEntity() else {
            assert(false, "Every visible node should be owned by an entity")
            return
        }

        let dragInfo = DragInfo.begin(entity, startVertex, endVertex, control, shift)

        if let hasMoveHandle = entity as? Entities.Feature.HasMoveHandle {
            // We don't actually drag game entities, we drag their drag-handles, and each drag-handle
            // moves its own entity. The user can begin a drag on a deselected entity, which necessarily
            // changes what is and isn't selected, so we have to tell the selection controller whenever
            // a begin drag happens
            selectionController.dispatchDrag(dragInfo)

            // After we've told the selection controller, the entity under the mouse is definitely
            // selected (therefore showing a handle), so we set up to drag the handle
            hotDragHandle = hasMoveHandle.moveHandle

        } else if let isMoveHandle = entity as? Entities.MoveHandle {

            // Dragging a move handle requires less setup
            hotDragHandle = isMoveHandle

        } else {
            assert(false, "Reputable scientists have said this cannot occur")
        }

        dragHandlePublisher.send(dragInfo)
        currentState = .dragHandle
    }

}
