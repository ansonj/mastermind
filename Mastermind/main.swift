import Foundation
let allowDuplicates = false
let debug = false
let trials = 1_000

let percentFormatter = {
    let f = NumberFormatter()
    f.numberStyle = .percent
    f.minimumFractionDigits = 1
    f.maximumFractionDigits = 1
    f.formatWidth = 6
    f.paddingPosition = .beforePrefix
    return f
}()
let minutesFormatter = {
    let f = NumberFormatter()
    f.numberStyle = .decimal
    f.maximumFractionDigits = 2
    return f
}()

var trialResults = [Runner.GameResult: Int]()
let startDate = Date()
for trialIndex in 1...trials {
    let game = Game(allowDuplicateColors: allowDuplicates)
    let strategy = AnsonsStrategy(allowDuplicateColors: allowDuplicates,
                                  debug: debug)
    let result = Runner.run(game: game,
                            withStrategy: strategy,
                            debug: false)
    trialResults[result, default: 0] += 1
    
    let formattedProgressPercentage = percentFormatter.string(from: (Double(trialIndex) / Double(trials)) as NSNumber)!
    print("Done with trial \(trialIndex) / \(trials) (\(formattedProgressPercentage))")
}
let formattedTrialDuration = minutesFormatter.string(from: (Date().timeIntervalSince(startDate) / 60.0) as NSNumber)!
print("I just played \(trials) games in \(formattedTrialDuration) minutes")
trialResults.keys.sorted(by: { left, right in
    switch (left, right) {
    case (.lost, .lost):
        return false
    case (.lost, .won):
        return false
    case (.won, .lost):
        return true
    case let (.won(leftWon), .won(rightWon)):
        return leftWon < rightWon
    }
}).forEach { result in
    let count = trialResults[result]!
    let percentage = Double(count) / Double(trials)
    let formattedPercentage = percentFormatter.string(from: percentage as NSNumber)!
    print("\t\(result): \(count)\t\(formattedPercentage)")
}
