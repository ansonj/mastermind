let allowDuplicates = false
let game = Game(allowDuplicateColors: allowDuplicates)
let strategy = AnsonsStrategy(allowDuplicateColors: allowDuplicates)

Runner.run(game: game,
           withStrategy: strategy)
