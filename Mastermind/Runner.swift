struct Runner {
    enum GameResult {
        case won(guesses: Int)
        case lost
    }
    
    static func run(game: Game, withStrategy strategy: Strategy) -> GameResult {
        print("Playing a game \(game.allowDuplicateColors ? "with" : "without") duplicates.")
        while game.status == .inProgress {
            let nextGuess = strategy.nextGuess(forHistory: game.guesses)
            do {
                let guessScore = try game.submit(guess: nextGuess)
                print("Guess \(game.guesses.count): \(guessScore)")
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        switch game.status {
        case .inProgress:
            fatalError("How are we still inProgress?")
        case .won:
            print("Won the game in \(game.guesses.count) guesses!")
            return .won(guesses: game.guesses.count)
        case .lost:
            assert(game.guesses.count == Game.maxNumberOfGuesses)
            print("Lost the game after \(game.guesses.count) guesses...")
            return .lost
        }
    }
}
