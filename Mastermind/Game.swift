struct Game {
    enum Status {
        case inProgress
        case won
        case lost
    }
    enum GuessError {
        case gameAlreadyLost
    }
    
    static let maxNumberOfGuesses = 10
    
    let allowDuplicateColors: Bool
    let solution: Combination
    private(set) var status = Status.inProgress
    private(set) var guesses = [Guess]()
    
    init(allowDuplicateColors: Bool) {
        self.allowDuplicateColors = allowDuplicateColors
        self.solution = Combination.randomized(allowingDuplicates: self.allowDuplicateColors)
    }
    
    /// Submits a guess to the game history.
    /// Scores the given guess, increments the guess count, and updates the game status.
    func submit(guess: Combination) throws -> (CombinationScore, Status) {
        // Throw if you're out of guesses
        // Increment guesses
        // Update game status
        // Return the score and status
        fatalError("Not implemented")
    }
    
    /// Returns a score for the given guess and solution.
    static func score(guess: Combination, forSolution solution: Combination) -> CombinationScore {
        fatalError("Not implemented")
    }
}
