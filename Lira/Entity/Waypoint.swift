// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SpriteKit

extension Entities {

    final class Waypoint:
        Entity,
        Feature.HasAvatarSprite,
        Feature.HasMoveHandle
    {
        var moveHandle: MoveHandle { fatalError() }
        var sprite: Components.AvatarSprite { fatalError() }

    }

}
