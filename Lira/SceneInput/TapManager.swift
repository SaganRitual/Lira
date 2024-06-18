// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation

final class TapManager {
    /*
     Everything depends on what's selected, so the selectionController must
     be the first to know about tapping and dragging.

     Tap on the background can change selection; if so, selection change will
     happen at the time of the tap, as opposed to dragging on the background,
     which can also change selection, but it happens at dragEnd.

     If tap on the background results in creation of new entities, we need to
     talk to the selection controller again, to tell it to select the new
     entities.

     Tap on an entity can change selection; if so, it's gonna happen at the
     time of the tap. But it won't create any new entities (at least in the
     current version, so we don't need to talk to the selectionController twice
     for entity tap).

     See also notes in the drag functions. Managing mouse input is surprisingly tricky.
     */
    let game: SpriteWorld.Game
    let selectionController: SelectionController

    init(_ game: SpriteWorld.Game, _ selectionController: SelectionController) {
        self.game = game
        self.selectionController = selectionController
    }

    func tap(_ mouseContact: SceneInputManager.MouseContact) {
        guard let tappedNode = mouseContact.getTopNode!(mouseContact.sceneStart) else {
            // Tap on the background
            let tapInfo = TapInfo.tap(nil, mouseContact)

            // Always update the selection state first on any user input
            selectionController.dispatchTap(tapInfo)

            // Tell the game about tap on background, which currently
            // means only one thing: create new entities
            let newEntity = game.newEntity(tapInfo) as! SelectableEntity

            // At least for now, we always select the newly created entity
            selectionController.newSelectableCreated(newEntity)
            return
        }

        guard let entity = tappedNode.getOwnerEntity() else {
            assert(false, "Every visible node should be owned by an entity")
            return
        }

        let tapInfo = TapInfo.tap(entity, mouseContact)
        selectionController.dispatchTap(tapInfo)
    }

}
