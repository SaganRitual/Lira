// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation

extension String {
    func padLeft(targetLength: Int, padCharacter: String = " ") -> String {
        guard targetLength > count else { return self }

        return String(repeating: padCharacter, count: targetLength - count) + self
    }
}

extension CGPoint: CustomStringConvertible {
    public var description: String {
        "(" + String(format: "%.2f", x) + ", " + String(format: "%.2f", y) + ")"
    }
}

extension CGSize: CustomStringConvertible {
    public var description: String {
        String(format: "%.2f", width) + " x " + String(format: "%.2f", height)
    }
}

extension CGVector: CustomStringConvertible {
    public var description: String {
        "(" + String(format: "%.2f", dx) + ", " + String(format: "%.2f", dy) + ")"
    }
}
