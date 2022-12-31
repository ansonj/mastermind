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
    
    func score(guess: Combination) throws -> CombinationScore {
        // Throw if you're out of guesses
        // Increment guesses
        // Update game status
        // Return the score
        fatalError("Not implemented")
    }
}
