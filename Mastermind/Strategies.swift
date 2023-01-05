protocol Strategy {
    init(allowDuplicateColors: Bool)
    func nextGuess(forHistory history: [Guess]) -> Combination
}

struct AnsonsStrategy: Strategy {
    let allowDuplicateColors: Bool
    
    init(allowDuplicateColors: Bool) {
        self.allowDuplicateColors = allowDuplicateColors
    }
    
    func nextGuess(forHistory history: [Guess]) -> Combination {
        // If we know the solution already, just submit that.
        for guess in history {
            if guess.score == CombinationScore.solutionScore {
                return guess.combination
            }
        }
        
        var possibleSolutions: [Combination]
        if allowDuplicateColors {
            possibleSolutions = AllCombinations.withDuplicates
        } else {
            possibleSolutions = AllCombinations.withoutDuplicates
        }
        
        // Remove combinations that don't produce the possible score for each guess
        do {
            var possibleSolutionIndex = 0
            while possibleSolutionIndex < possibleSolutions.count {
                let candidateCombination = possibleSolutions[possibleSolutionIndex]
                var removedThisCandidate = false
                
                for guess in history {
                    let candidateScore = Game.score(guess: guess.combination, forSolution: candidateCombination)
                    if candidateScore != guess.score {
                        possibleSolutions.remove(at: possibleSolutionIndex)
                        removedThisCandidate = true
                        break
                    }
                }
                
                if !removedThisCandidate {
                    possibleSolutionIndex += 1
                }
            }
        }
        assert(possibleSolutions.count > 0, "We don't have any possible solutions for this game.")
        for combination in possibleSolutions {
            assert(!history.map(\.combination).contains(combination), "Assuming that we haven't found the solution yet, all previous guesses should be disqualified as possible solutions.")
        }
        
        // Build all combinations with the most likely pegs in each position
        let mostLikelySolutions: [Combination]
        do {
            // Again, we rely on the assumption that there are only four pegs in the game to simplify the code.
            func options(forPegPosition pegPosition: Int) -> [PegColor] {
                // This code works, but it's nearly impossible to read.
                // TODO: Rewrite so this function is easier to read.
                // Make a list of the nth peg from each possible solution.
                let pegsInThisPositionFromAllSolutions = possibleSolutions.map { $0[pegPosition] }
                // Build a dictionary:
                // - Keys are an integer `x` representing the count of solutions in which a particular peg color appears.
                // - Values are the peg colors that appear in `x` solutions.
                let countDictionary = Dictionary(grouping: pegsInThisPositionFromAllSolutions, by: { g in
                    pegsInThisPositionFromAllSolutions.filter({ f in f == g }).count
                }).mapValues({ Array<PegColor>(Set<PegColor>($0)) })
                // Take the key with the highest value (the highest count for which some pegs appear),
                // and return the list of pegs that appear that many times.
                return countDictionary[countDictionary.keys.max() ?? -1] ?? []
            }
            let firstPegOptions = options(forPegPosition: 0)
            let secondPegOptions = options(forPegPosition: 1)
            let thirdPegOptions = options(forPegPosition: 2)
            let fourthPegOptions = options(forPegPosition: 3)
            var mostLikelyCombinationsBuilder = [Combination]()
            for firstPeg in firstPegOptions {
                for secondPeg in secondPegOptions {
                    for thirdPeg in thirdPegOptions {
                        for fourthPeg in fourthPegOptions {
                            let candidate = [firstPeg, secondPeg, thirdPeg, fourthPeg]
                            let candidateIsAllowedAsPerDuplicates = allowDuplicateColors || Set<PegColor>(candidate).count == 4
                            let candidateHasNotBeenGuessedBefore = !history.map(\.combination).contains(candidate)
                            if candidateIsAllowedAsPerDuplicates && candidateHasNotBeenGuessedBefore {
                                mostLikelyCombinationsBuilder.append(candidate)
                            }
                        }
                    }
                }
            }
            mostLikelySolutions = mostLikelyCombinationsBuilder
        }
        
        // mostLikelySolutions contains only things that we haven't guessed yet.
        // But somtimes, the the "most likely" solutions will be ONLY things that we have already guessed.
        // So, if we can't rely on our probability logic to produce a "most likely" solution, let's just pick the first possible solution and return it as our next guess.
        return mostLikelySolutions.first ?? possibleSolutions.first!
    }
}

private struct AllCombinations {
    static let withoutDuplicates = buildCombinations(allowingDuplicates: false)
    static let withDuplicates = buildCombinations(allowingDuplicates: true)
    
    private static func buildCombinations(allowingDuplicates: Bool) -> [Combination] {
        var combinations = [Combination]()
        // Because we're assuming that there are four pegs in a solution, we can give ourselves a break and just write out all the loops manually.
        for firstPeg in PegColor.allCases {
            for secondPeg in PegColor.allCases {
                for thirdPeg in PegColor.allCases {
                    for fourthPeg in PegColor.allCases {
                        let combination = [firstPeg, secondPeg, thirdPeg, fourthPeg]
                        // TODO: Deduplicate this duplicates check by writing Array.containsDuplicates
                        let combinationIncludesDuplicates = Set<PegColor>(combination).count != 4
                        if allowingDuplicates || !combinationIncludesDuplicates {
                            combinations.append(combination)
                        }
                    }
                }
            }
        }
        let countOfPegs = PegColor.allCases.count
        if allowingDuplicates {
            let expectedCount = countOfPegs ^ 4
            assert(expectedCount == combinations.count, "We didn't build the right number of combinations with duplicates")
        } else {
            let expectedCount = countOfPegs * (countOfPegs - 1) * (countOfPegs - 2) * (countOfPegs - 3)
            assert(expectedCount == combinations.count, "We didn't build the right number of combinations without duplicates")
        }
        return combinations
    }
}
