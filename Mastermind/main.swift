let allowDuplicates = false
let debug = false

let game = Game(allowDuplicateColors: allowDuplicates)
let strategy = AnsonsStrategy(allowDuplicateColors: allowDuplicates,
                              debug: debug)

_ = Runner.run(game: game,
               withStrategy: strategy,
               debug: debug)
