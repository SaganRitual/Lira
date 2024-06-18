// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            SpriteWorldView()
                .padding()

            DashboardView()
        }
    }
}
