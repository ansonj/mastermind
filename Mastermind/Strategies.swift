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
            var possibleCombinationIndex = 0
            while possibleCombinationIndex < possibleSolutions.count {
                let candidateCombination = possibleSolutions[possibleCombinationIndex]
                var removedThisCandidate = false
                
                for guess in history {
                    let candidateScore = Game.score(guess: guess.combination, forSolution: candidateCombination)
                    if candidateScore != guess.score {
                        possibleSolutions.remove(at: possibleCombinationIndex)
                        removedThisCandidate = true
                        break
                    }
                }
                
                if !removedThisCandidate {
                    possibleCombinationIndex += 1
                }
            }
        }
        assert(possibleSolutions.count > 0, "We don't have any possible solutions for this game.")
        for combination in possibleSolutions {
            assert(!history.map(\.combination).contains(combination), "Assuming that we haven't found the solution yet, all previous guesses should be disqualified as possible solutions.")
        }
        
        // Build a combination with the most likely pegs in each position
        let nextGuess: Combination
        do {
            struct PegProbability {
                let color: PegColor
                let position: Int
                let probability: Double
            }
            var allProbabilities = [PegProbability]()
            let totalNumberOfCombinations = Double(possibleSolutions.count)
            for pegIndex in 0..<possibleSolutions.first!.count {
                for color in PegColor.allCases {
                    let count = possibleSolutions.filter({ $0[pegIndex] == color }).count
                    let probability = Double(count) / totalNumberOfCombinations
                    allProbabilities.append(PegProbability(color: color,
                                                           position: pegIndex,
                                                           probability: probability))
                }
            }
            allProbabilities.sort { left, right in
                left.probability > right.probability
            }
            
            var nextGuessBuilder: [PegColor?] = [nil, nil, nil, nil]
            for probability in allProbabilities {
                if nextGuessBuilder[probability.position] == nil && (allowDuplicateColors || !nextGuessBuilder.contains(probability.color)) {
                    nextGuessBuilder[probability.position] = probability.color
                }
                if !nextGuessBuilder.contains(nil) {
                    break
                }
            }
            assert(!nextGuessBuilder.contains(nil), "We should have filled in all the positions by now")
            nextGuess = nextGuessBuilder.compactMap({ $0 })
            assert(nextGuess.count == 4, "We somehow ended up with a guess with the wrong length")
        }
        
        return nextGuess
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
