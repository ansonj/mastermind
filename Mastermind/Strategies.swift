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
        fatalError("Not implemented")
    }
}
