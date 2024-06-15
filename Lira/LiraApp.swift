// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

@main
struct LiraApp: App {
    let appState = AppState()
    let sceneInfo = SceneInfo()

    var body: some Scene {
        WindowGroup {
            ContentView(appState: appState)
                .environmentObject(sceneInfo)
        }
    }
}
