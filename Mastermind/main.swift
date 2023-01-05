let allowDuplicates = false
let debug = false
let trials = 1_000

var trialResults = [Runner.GameResult: Int]()
for _ in 0..<trials {
    let game = Game(allowDuplicateColors: allowDuplicates)
    let strategy = AnsonsStrategy(allowDuplicateColors: allowDuplicates,
                                  debug: debug)
    let result = Runner.run(game: game,
                            withStrategy: strategy,
                            debug: false)
    trialResults[result, default: 0] += 1
}
print("I just played \(trials) games")
trialResults.keys.sorted(by: { left, right in
    switch (left, right) {
    case (.lost, .lost):
        return false
    case (.lost, .won):
        return true
    case (.won, .lost):
        return false
    case let (.won(leftWon), .won(rightWon)):
        return leftWon < rightWon
    }
}).forEach { result in
    print("\t\(result): \(trialResults[result]!)")
}
