// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit
import SwiftUI

struct SpriteWorldView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var sceneInfo: SceneInfo

    func getMouseContact(
        _ dragGestureValue: DragGesture.Value, _ control: Bool, _ shift: Bool
    ) -> SceneInputManager.MouseContact {
        let sv = sceneInfo.convertPoint(dragGestureValue.startLocation)
        let ev = sceneInfo.convertPoint(dragGestureValue.location)

        return SceneInputManager.MouseContact(
            viewStart: dragGestureValue.startLocation,
            viewEnd: dragGestureValue.location,
            sceneStart: sv,
            sceneEnd: ev,
            control: control,
            shift: shift,
            getTopNode: appState.scene.getTopNode
        )
    }

    func getMouseContact(
        _ positionInView: CGPoint, _ control: Bool, _ shift: Bool
    ) -> SceneInputManager.MouseContact {
        let sv = sceneInfo.convertPoint(positionInView)

        return SceneInputManager.MouseContact(
            viewStart: positionInView,
            sceneStart: sv,
            control: control,
            shift: shift,
            getTopNode: appState.scene.getTopNode
        )
    }

    var body: some View {
        ZStack {
            SpriteView(
                scene: appState.scene,
                debugOptions: [.showsFields, .showsFPS, .showsNodeCount, .showsPhysics]
            )
            .background(GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        sceneInfo.viewSize = geometry.size
                    }
                    .onChange(of: geometry.size) { (_, newSize) in
                        sceneInfo.viewSize = newSize
                    }
            })

            RightClickableView(onRightClick: {
                appState.sceneInputManager.rightClick(SceneInputManager.MouseContact(viewStart: sceneInfo.hoverLocation!))
            })
            .frame(width: sceneInfo.viewSize.width, height: sceneInfo.viewSize.height)
            .contentShape(Rectangle()) // Ensure the entire area is clickable
        }

        .gesture(
            DragGesture().modifiers(.shift)
                .onChanged { value in
                    appState.sceneInputManager.drag(getMouseContact(value, false, true))
                }
                .onEnded { value in
                    appState.sceneInputManager.dragEnd(getMouseContact(value, false, true))
                }
        )

        .gesture(
            DragGesture()
                .onChanged { value in
                    appState.sceneInputManager.drag(getMouseContact(value, false, false))
                }
                .onEnded { value in
                    appState.sceneInputManager.dragEnd(getMouseContact(value, false, false))
                }
        )

        .gesture(
            TapGesture().modifiers(.control).onEnded {
                appState.sceneInputManager.tap(getMouseContact(sceneInfo.hoverLocation!, true, false))
            }
        )

        .gesture(
            TapGesture().modifiers(.shift).onEnded {
                appState.sceneInputManager.tap(getMouseContact(sceneInfo.hoverLocation!, false, true))
            }
        )

        .gesture(
            TapGesture().onEnded {
                appState.sceneInputManager.tap(getMouseContact(sceneInfo.hoverLocation!, false, false))
            }
        )

        // With eternal gratitude to Natalia Panferova
        // Using .onContinuousHover to track mouse position
        // https://nilcoalescing.com/blog/TrackingHoverLocationInSwiftUI/
        .onContinuousHover { phase in
            switch phase {
            case .active(let location):
                sceneInfo.hoverLocation = location
            case .ended:
                sceneInfo.hoverLocation = nil
            }
        }
    }
}
