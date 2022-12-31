enum PegColor {
    case white
    case red
    case yellow
    case green
    case blue
    case black
}

typealias Combination = [PegColor]

extension Combination {
    static var random: Self {
        fatalError("Not yet implemented")
    }
}

struct CombinationScore {
    /// Correct color, correct position
    let blackScorePegs: Int
    /// Correct color, incorrect position
    let whiteScorePegs: Int
}

struct Guess {
    let combination: Combination
    let score: CombinationScore
}
