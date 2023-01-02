class Game {
    enum Status {
        case inProgress
        case won
        case lost
    }
    enum GuessError: Error {
        case gameAlreadyOver
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
        guard status == .inProgress else {
            throw GuessError.gameAlreadyOver
        }
        
        let score = Self.score(guess: guess,
                               forSolution: solution)
        guesses.append(Guess(combination: guess,
                             score: score))

        if guess == solution {
            status = .won
        } else if guesses.count >= Self.maxNumberOfGuesses {
            status = .lost
        }
        
        return (score, status)
    }
    
    /// Returns a score for the given guess and solution.
    static func score(guess: Combination, forSolution solution: Combination) -> CombinationScore {
        precondition(guess.count == solution.count, "Your guess has \(guess.count) pegs versus the solution which has \(solution.count) pegs")
        
        var blackScorePegCount = 0
        var whiteScorePegCount = 0
        for index in 0..<guess.count {
            if solution[index] == guess[index] {
                blackScorePegCount += 1
            } else if guess.contains(solution[index]) {
                whiteScorePegCount += 1
            }
        }
        
        return CombinationScore(blackScorePegs: blackScorePegCount,
                                whiteScorePegs: whiteScorePegCount)
    }
}
