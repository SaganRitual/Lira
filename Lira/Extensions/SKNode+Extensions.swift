// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SpriteKit

extension SKNode {
    func getOwnerEntity() -> Entity? {
        guard let entry = userData?["ownerEntity"] else { return nil }
        return entry as? Entity
    }

    func setOwnerEntity(_ entity: Entity) {
        if userData == nil { userData = [:] }
        userData!["ownerEntity"] = entity
    }

    func hide() { isHidden = true }
    func show() { isHidden = false }
    func toggleVisible() { isHidden = !isHidden }
}
