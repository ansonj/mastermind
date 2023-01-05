struct Runner {
    enum GameResult: Hashable {
        case won(guesses: Int)
        case lost
    }
    
    static func run(game: Game, withStrategy strategy: Strategy, debug: Bool) -> GameResult {
        func debugPrint(_ message: String) {
            if debug {
                print(message)
            }
        }
        debugPrint("Playing a game \(game.allowDuplicateColors ? "with" : "without") duplicates.")
        debugPrint("The solution is \(game.solution).")
        while game.status == .inProgress {
            let nextGuess = strategy.nextGuess(forHistory: game.guesses)
            do {
                let guessScore = try game.submit(guess: nextGuess)
                debugPrint("Guess \(game.guesses.count): \(nextGuess) --> \(guessScore)")
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        switch game.status {
        case .inProgress:
            fatalError("How are we still inProgress?")
        case .won:
            debugPrint("Won the game in \(game.guesses.count) guesses!")
            return .won(guesses: game.guesses.count)
        case .lost:
            assert(game.guesses.count == Game.maxNumberOfGuesses)
            debugPrint("Lost the game after \(game.guesses.count) guesses...")
            return .lost
        }
    }
}
