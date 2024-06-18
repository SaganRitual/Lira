// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation

final class AppState: ObservableObject {
    let game: SpriteWorld.Game
    let scene: SpriteWorld.Scene
    let sceneInputManager: SceneInputManager
    let selectionController: SelectionController
    let selectionMarquee: SpriteWorld.SelectionMarquee

    init() {
        let scene = SpriteWorld.Scene()
        let selectionController = SelectionController(scene)
        let selectionMarquee = SpriteWorld.SelectionMarquee(scene)
        let dragManager = DragManager(selectionController, selectionMarquee)
        let game = SpriteWorld.Game(dragManager, scene)
        let tapManager = TapManager(game, selectionController)
        let sceneInputManager = SceneInputManager(dragManager, tapManager)

        self.game = game
        self.scene = scene
        self.sceneInputManager = sceneInputManager
        self.selectionController = selectionController
        self.selectionMarquee = selectionMarquee
    }
}
