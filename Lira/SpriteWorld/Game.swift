// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SpriteKit

extension SpriteWorld {
    
    final class Game {
        let scene = Scene()
        let sceneInputManager: SceneInputManager
        let selectionController = SelectionController()
        
        func newEntity(_ tapInfo: TapInfo) -> Entity { fatalError() }
        
        func getOwnerEntity(for node: SKNode) -> Entity? { nil }
    }
    
}
