// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var sceneInfo: SceneInfo

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Text("SpriteKit Playground")
                Spacer()
            }
            .padding(.bottom)
            
            HStack {
                Spacer()
                Text("Size").underline()
                Spacer()
            }
            .padding(.bottom)
            
            HStack {
                Text("View/Scene")
                Spacer()
                Text("\(sceneInfo.viewSize)")
            }
            .padding(.bottom)
            
            MouseInfoView()
        }
    }
}
