// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit
import SwiftUI

struct SpriteWorldView: View {
    @ObservedObject var sceneInfo: SceneInfo

    @State private var game: Game

    // With eternal gratitude to
    // https://forums.developer.apple.com/forums/profile/billh04
    // Adding a nearly invisible view to make DragGesture() respond
    // https://forums.developer.apple.com/forums/thread/724082
    let glassPaneColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.01)

    init(sceneInfo: SceneInfo, game: Game) {
        self.sceneInfo = sceneInfo
        self.game = game
    }

    var body: some View {
        ZStack {
            SpriteView(
                scene: game.scene,
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
        }

        .gesture(
            DragGesture().modifiers(.shift)
                .onChanged { value in
                    sceneInfo.hoverLocation = value.location
                    game.sceneInputManager.drag(value.startLocation, value.location, false, true)
                }
                .onEnded { value in
                    sceneInfo.hoverLocation = value.location
                    game.sceneInputManager.dragEnd(value.startLocation, value.location, false, true)
                }
        )

        .gesture(
            DragGesture()
                .onChanged { value in
                    sceneInfo.hoverLocation = value.location
                    game.sceneInputManager.drag(value.startLocation, value.location, false, false)
                }
                .onEnded { value in
                    sceneInfo.hoverLocation = value.location
                    game.sceneInputManager.dragEnd(value.startLocation, value.location, false, false)
                }
        )

        .gesture(
            TapGesture().modifiers(.control).onEnded {
                game.sceneInputManager.tap(at: sceneInfo.hoverLocation!, true, false)
            }
        )

        .gesture(
            TapGesture().modifiers(.shift).onEnded {
                game.sceneInputManager.tap(at: sceneInfo.hoverLocation!, false, true)
            }
        )

        .gesture(
            TapGesture().onEnded {
                game.sceneInputManager.tap(at: sceneInfo.hoverLocation!, false, false)
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
