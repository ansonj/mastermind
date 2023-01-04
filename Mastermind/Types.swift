import Foundation

enum PegColor: CaseIterable {
    case white
    case red
    case yellow
    case green
    case blue
    case black
}
extension PegColor: CustomStringConvertible {
    var description: String {
        switch self {
        case .white:
            return "white"
        case .red:
            return "red"
        case .yellow:
            return "yellow"
        case .green:
            return "green"
        case .blue:
            return "blue"
        case .black:
            return "black"
        }
    }
}

/// We assume throughout the code that a combination contains exactly four pegs.
typealias Combination = [PegColor]

extension Combination {
    static func randomized(allowingDuplicates: Bool) -> Self {
        var result = Self()
        while result.count < 4 {
            let randomIndex = Int(arc4random_uniform(UInt32(PegColor.allCases.count)))
            let randomPeg = PegColor.allCases[randomIndex]
            // (A || !C) == (A || (!A && !C))
            if allowingDuplicates || !result.contains(randomPeg) {
                result.append(randomPeg)
            }
        }
        return result
    }
}

struct CombinationScore: Equatable {
    /// Correct color, correct position
    let blackScorePegs: Int
    /// Correct color, incorrect position
    let whiteScorePegs: Int
    
    static let solutionScore = CombinationScore(blackScorePegs: 4, whiteScorePegs: 0)
}
extension CombinationScore: CustomStringConvertible {
    var description: String {
        "(b: \(blackScorePegs), w: \(whiteScorePegs))"
    }
}

struct Guess {
    let combination: Combination
    let score: CombinationScore
}
