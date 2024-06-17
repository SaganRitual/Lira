// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit
import SwiftUI

struct SpriteWorldView: View {
    @EnvironmentObject var sceneInfo: SceneInfo

    @State private var appState: AppState

    // With eternal gratitude to
    // https://forums.developer.apple.com/forums/profile/billh04
    // Adding a nearly invisible view to make DragGesture() respond
    // https://forums.developer.apple.com/forums/thread/724082
    let glassPaneColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.01)

    init(appState: AppState) {
        self.appState = appState
    }

    var body: some View {
        ZStack {
            SpriteView(
                scene: appState.scene,
                debugOptions: [.showsFields, .showsFPS, .showsNodeCount, .showsPhysics]
            )

            Color(cgColor: glassPaneColor)
                .background() {
                    GeometryReader { geometry in
                        Path { _ in
                            DispatchQueue.main.async {
                                if sceneInfo.viewSize != geometry.size {
                                    sceneInfo.viewSize = geometry.size
                                }
                            }
                        }
                    }
                }

            RightClickableView(onRightClick: {
                appState.sceneInputManager.rightClick(sceneInfo.hoverLocation!, false, false) // Example action
            })
            .frame(width: sceneInfo.viewSize.width, height: sceneInfo.viewSize.height)
            .contentShape(Rectangle()) // Ensure the entire area is clickable
        }

        .gesture(
            DragGesture().modifiers(.shift)
                .onChanged { value in
                    sceneInfo.hoverLocation = value.location
                    appState.sceneInputManager.drag(value.startLocation, value.location, false, true)
                }
                .onEnded { value in
                    sceneInfo.hoverLocation = value.location
                    appState.sceneInputManager.dragEnd(value.startLocation, value.location, false, true)
                }
        )

        .gesture(
            DragGesture()
                .onChanged { value in
                    sceneInfo.hoverLocation = value.location
                    appState.sceneInputManager.drag(value.startLocation, value.location, false, false)
                }
                .onEnded { value in
                    sceneInfo.hoverLocation = value.location
                    appState.sceneInputManager.dragEnd(value.startLocation, value.location, false, false)
                }
        )

        .gesture(
            TapGesture().modifiers(.control).onEnded {
                appState.sceneInputManager.tap(sceneInfo.hoverLocation!, true, false)
            }
        )

        .gesture(
            TapGesture().modifiers(.shift).onEnded {
                appState.sceneInputManager.tap(sceneInfo.hoverLocation!, false, true)
            }
        )

        .gesture(
            TapGesture().onEnded {
                appState.sceneInputManager.tap(sceneInfo.hoverLocation!, false, false)
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
