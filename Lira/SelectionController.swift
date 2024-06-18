// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import Foundation

final class SelectionController {
    enum EntityCategory {
        case gremlin, handle, waypoint
    }

    let scene: SpriteWorld.Scene

    private var draggingEntity = false

    init(_ scene: SpriteWorld.Scene) {
        self.scene = scene
    }

    func getSelected() -> Set<SelectableEntity>? {
        guard let selected = getSelectable()?.filter({ $0.isSelected }) else  {
            return nil
        }

        return Set(selected)
    }

    func newSelectableCreated(_ entity: Entities.Feature.IsSelectable) {
        entity.select()
    }
}

extension SelectionController {

    // Something to notice about selection: when the user drags an entity, any change
    // in selection state happens at the begin drag; when the user drags a selection
    // marquee, any change in selection state happens at the end drag.
    func dispatchDrag(_ dragInfo: DragInfo) {
        switch dragInfo.phase {
        case .begin:
            if let entity = dragInfo.entity {
                draggingEntity = true

                // Handles, for example, aren't selectable; non-selectable entities
                // don't get any help from the selection controller
                guard let selectable = entity as? SelectableEntity else {
                    return
                }

                // If we're dragging an entity, selection might be affected. Specifically,
                // if the entity being dragged (the one under the click) is already selected,
                // we'll drag it and all the other selected entities as a group. If it's not
                // selected then the whole selection set changes, the one entity becomes uniquely
                // selected, so it's dragged alone
                if !selectable.isSelected {
                    deselectAll()
                    select(selectable)
                }
            } else {
                draggingEntity = false
            }
        case .continue:
            break

        case .end:
            // If we're dragging an entity, this is the drop. Selection isn't affected at drop time
            if draggingEntity {
                return
            }

            // The rectangle described by the selection marquee drives the new selection state
            let sv = dragInfo.startVertexInScene
            let ev = dragInfo.endVertexInScene
            let rect = makeRectangle(vertexA: sv, vertexB: ev)

            guard let selectables = getSelectable(in: rect) else {
                if !dragInfo.shift {
                    deselectAll()
                }

                return
            }

            if dragInfo.shift {
                toggleSelect(selectables)
            } else {
                deselectAll()
                select(selectables)
            }
        }
    }

    func dispatchTap(_ tapInfo: TapInfo) {
        if let entity = tapInfo.entity {
            // Tap on an entity

            if let selectable = entity as? Entity & Entities.Feature.IsSelectable {
                // Tap on a selectable entity; note that if an entity is selected you can't
                // tap on it, because its selection handle is sitting on top of it. You can
                // only tap on the selection handle, which isn't a selectable entity.

                // Therefore

                // This is a tap on non-selected selectable entity. We'll select it, but
                // first check the shift key. Shift-tap on an entity adds it to
                // the selection set. Normal tap deselects everything else first

                if !tapInfo.shift {
                    deselectAll()
                }

                selectable.select()
                return
            }

            // Tap on non-selectable entity

            if let handle = entity as? Entities.MoveHandle {
                // Tap on a selection handle
                if tapInfo.shift {
                    handle.targetEntity.deselect()
                }

                // Control-tap will bring up a context menu for the target entity
                // Plain-tap will do nothing

                return
            }

            assert(false, "Tap on non-selectable entity that isn't a handle?")
        }

        // Tap on the background

        deselectAll()
    }

}

private extension SelectionController {

    func deselectAll() {
        getSelected()?.forEach { $0.deselect() }
    }

    func getSelectable() -> Set<SelectableEntity>? {
        let selected: [SelectableEntity] = scene.rootNode.children.compactMap { node in
            guard let entity = node.getOwnerEntity() as? SelectableEntity else {
                return nil
            }

            return entity.isSelected ? entity : nil
        }

        return selected.isEmpty ? nil : Set(selected)
    }

    func getSelectable(in rectangle: CGRect) -> Set<SelectableEntity>? {
        let nodes = scene.getNodes(in: rectangle)

        if nodes.isEmpty { return nil }

        let entities = nodes.compactMap { node in
            node.getOwnerEntity() as? SelectableEntity
        }

        return Set(entities)
    }

    func getSelectionState() -> [Entity.Type] {
        var result: [Entity.Type] = []

        getSelected()?.forEach { entity in
            if !result.contains(where: { $0 == type(of: entity) }) {
                result.append(type(of: entity))
            }
        }

        return result
    }

    func getTopSelectable(at positionInView: CGPoint) -> Entity? {
        guard
            let node = scene.getTopNode(at: positionInView),
            let entity = node.getOwnerEntity() else {
            return nil
        }

        return entity
    }

    func select(_ entity: SelectableEntity) {
        entity.select()
    }

    func select(_ entities: Set<SelectableEntity>) {
        entities.forEach { select($0) }
    }

    func toggleSelect(_ entity: SelectableEntity) {
        entity.toggleSelect()
    }

    func toggleSelect(_ entities: Set<SelectableEntity>) {
        entities.forEach { toggleSelect($0) }
    }

}

private extension SelectionController {

    func makeRectangle(vertexA: CGPoint, vertexB: CGPoint) -> CGRect {
        let LL = CGPoint(x: min(vertexA.x, vertexB.x), y: min(vertexA.y, vertexB.y))
        let UR = CGPoint(x: max(vertexA.x, vertexB.x), y: max(vertexA.y, vertexB.y))

        let size = CGSize(width: UR.x - LL.x, height: UR.y - LL.y)

        return CGRect(origin: LL, size: size)
    }

}

