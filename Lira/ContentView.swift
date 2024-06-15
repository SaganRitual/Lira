// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    let appState: AppState

    var body: some View {
        SpriteWorldView(appState: appState)
            .padding()
    }
}
