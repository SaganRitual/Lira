// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation

final class SelectionController {
    func dispatch(_ dragInfo: DragInfo) { }
    func dispatch(_ tapInfo: TapInfo) { }
    func select(_ entity: Entity) { }
}
