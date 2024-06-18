// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

@main
struct LiraApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var sceneInfo = SceneInfo()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(sceneInfo)
        }
    }
}
