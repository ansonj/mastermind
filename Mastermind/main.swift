let allowDuplicates = false
let game = Game(allowDuplicateColors: allowDuplicates)
let strategy = AnsonsStrategy(allowDuplicateColors: allowDuplicates)

_ = Runner.run(game: game,
               withStrategy: strategy)
