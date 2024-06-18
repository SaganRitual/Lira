// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SwiftUI

extension ActionTokens {

    class Stage: ObservableObject {
        @Published var tokens = [ActionTokens.Base]()
    }

}
