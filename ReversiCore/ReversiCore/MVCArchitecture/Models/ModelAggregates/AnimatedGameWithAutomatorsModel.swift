import ReactiveSwift



public protocol AnimatedGameWithAutomatorsModelProtocol: GameModelProtocol, GameWithAutomatorsModelProtocol, AnimatedGameModelProtocol {}



public class AnimatedGameWithAutomatorsModel: AnimatedGameWithAutomatorsModelProtocol {
    private let gameModel: GameModelProtocol
    private let animatedGameModel: AnimatedGameModelProtocol
    private let animatedGameWithAutomatorsModel: GameWithAutomatorsModelProtocol


    public init(
        gameModel: GameModelProtocol,
        gameAutomatorAvailabilitiesModel: GameAutomatorAvailabilitiesModelProtocol,
        automatorStrategy: @escaping CoordinateSelector
    ) {
        self.gameModel = gameModel

        let animatedGameModel = AnimatedGameModel(gameModel: gameModel)
        self.animatedGameModel = animatedGameModel

        self.animatedGameWithAutomatorsModel = GameWithAutomatorsModel(
            automatableGameModel: animatedGameModel,
            automatorModel: GameAutomatorModel(strategy: automatorStrategy),
            automationAvailabilityModel: gameAutomatorAvailabilitiesModel
        )
    }
}



extension AnimatedGameWithAutomatorsModel: GameCommandReceivable {
    public func pass() -> GameCommandResult {
        self.animatedGameWithAutomatorsModel.pass()
    }


    public func place(at coordinate: Coordinate) -> GameCommandResult {
        self.animatedGameWithAutomatorsModel.place(at: coordinate)
    }


    public func reset() -> GameCommandResult {
        self.animatedGameWithAutomatorsModel.reset()
    }
}



extension AnimatedGameWithAutomatorsModel: GameModelProtocol {
    public var gameModelStateDidChange: Property<GameModelState> { self.gameModel.gameModelStateDidChange }
}



extension AnimatedGameWithAutomatorsModel: BoardAnimationCommandReceivable {
    public func markAnimationAsCompleted() {
        self.animatedGameModel.markAnimationAsCompleted()
    }
}



extension AnimatedGameWithAutomatorsModel: AnimatedGameModelProtocol {
    public var animatedGameStateDidChange: ReactiveSwift.Property<AnimatedGameModelState> {
        self.animatedGameModel.animatedGameStateDidChange
    }
}



extension AnimatedGameWithAutomatorsModel: GameAutomatorProgressModelProtocol {
    public var automatorDidProgress: ReactiveSwift.Property<GameAutomatorProgress> {
        self.animatedGameWithAutomatorsModel.automatorDidProgress
    }
}



extension AnimatedGameWithAutomatorsModel: GameAutomatorAvailabilitiesModelProtocol {
    public var availabilitiesDidChange: ReactiveSwift.Property<GameAutomatorAvailabilities> {
        self.animatedGameWithAutomatorsModel.availabilitiesDidChange
    }


    public func update(availabilities: GameAutomatorAvailabilities) {
        self.animatedGameWithAutomatorsModel.update(availabilities: availabilities)
    }
}



extension AnimatedGameWithAutomatorsModel: GameWithAutomatorsModelProtocol {
    public var gameWithAutomatorsModelStateDidChange: ReactiveSwift.Property<GameWithAutomatorsModelState> {
        self.animatedGameWithAutomatorsModel.gameWithAutomatorsModelStateDidChange
    }


    public func cancel() -> GameCommandResult {
        self.animatedGameWithAutomatorsModel.cancel()
    }
}



extension AnimatedGameWithAutomatorsModel /* : AutomatableGameModelProtocol */ {
    public var automatableGameStateDidChange: ReactiveSwift.Property<AutomatableGameModelState> {
        self.animatedGameModel.automatableGameStateDidChange
    }
}
