// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation

struct TapInfo {
    let control: Bool
    let entity: Entity?
    let position: CGPoint
    let shift: Bool

    static func tap(_ entity: Entity?, _ position: CGPoint, _ control: Bool, _ shift: Bool) -> TapInfo {
        TapInfo(entity, position, control, shift)
    }

    private init(_ entity: Entity?, _ position: CGPoint, _ control: Bool, _ shift: Bool) {
        self.control = control
        self.shift = shift
        self.entity = entity
        self.position = position
    }
}
