// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SpriteKit

final class Waypoint:
    Entity,
    Components.Feature.HasAvatarSprite,
    Components.Feature.HasMoveHandle
{

    var moveHandle: Entities.MoveHandle { .init() }
    var sprite: SKSpriteNode { .init() }

}
