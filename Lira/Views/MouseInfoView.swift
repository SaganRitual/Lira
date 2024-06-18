// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct MouseInfoView: View {
    @EnvironmentObject var sceneInfo: SceneInfo

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Mouse").underline()
                Spacer()
            }
            .padding(.bottom)
            
            if let hoverLocation = sceneInfo.hoverLocation {
                HStack {
                    Text("SwiftUI View")
                    Spacer()
                    Text("\(hoverLocation)")
                }

                HStack {
                    Text("SpriteKit Scene")
                    Spacer()
                    Text("\(sceneInfo.convertPoint(hoverLocation))")
                }
                .padding(.bottom, 10)
            } else {
                Text("N/A")
                    .padding(.bottom, 10 + 16)
            }
        }
    }
}
