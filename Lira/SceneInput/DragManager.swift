// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import Foundation

final class DragManager {

    let dragHandlePublisher = PassthroughSubject<DragInfo, Never>()
    let selectionController: SelectionController
    let selectionMarquee: SpriteWorld.SelectionMarquee

    enum State {
        case dragBackground, dragHandle, idle
    }

    var currentState = State.idle
    var hotDragHandle: Entity?

    init(
        _ selectionController: SelectionController,
        _ selectionMarquee: SpriteWorld.SelectionMarquee
    ) {
        self.selectionController = selectionController
        self.selectionMarquee = selectionMarquee
    }

    func drag(_ mouseContact: SceneInputManager.MouseContact) {
        if currentState == .idle {
            dragBegin(mouseContact)
        }

        let dragInfo = DragInfo.continue(hotDragHandle, mouseContact)

        switch currentState {
        case .dragBackground:
            selectionMarquee.dispatchDrag(dragInfo)
        case .dragHandle:
            dragHandlePublisher.send(dragInfo)
        default:
            assert(false, "Reputable scientists have said this cannot occur")
        }
    }

    func dragEnd(_ mouseContact: SceneInputManager.MouseContact) {
        let dragInfo = DragInfo.end(hotDragHandle, mouseContact)

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

    func dragBegin(_ mouseContact: SceneInputManager.MouseContact) {
        guard let topNode = mouseContact.getTopNode!(mouseContact.sceneStart) else {
            selectionController.dispatchDrag(DragInfo.begin(nil, mouseContact))
            currentState = .dragBackground
            return
        }

        guard let entity = topNode.getOwnerEntity() else {
            assert(false, "Every visible node should be owned by an entity")
            return
        }

        let dragInfo = DragInfo.begin(entity, mouseContact)

        if let hasMoveHandle = entity as? Entities.Feature.HasMoveHandle {
            // We don't actually drag game entities, we drag their drag-handles, and each drag-handle
            // moves its own entity. The user can begin a drag on a deselected entity, which necessarily
            // changes what is and isn't selected, so we have to tell the selection controller whenever
            // a begin drag happens
            selectionController.dispatchDrag(dragInfo)

            // After we've told the selection controller, the entity under the mouse is definitely
            // selected (therefore showing a handle), so we set up to drag the handle
            hotDragHandle = hasMoveHandle.moveHandle

        } else if entity.isHandle {

            // Dragging a move handle requires less setup
            hotDragHandle = entity

        } else {
            assert(false, "Reputable scientists have said this cannot occur")
        }

        dragHandlePublisher.send(dragInfo)
        currentState = .dragHandle
    }

}
