import ReactiveSwift



public protocol DiskCountModelProtocol: class {
    var diskCountDidChange: ReactiveSwift.Property<DiskCount> { get }
}



public extension DiskCountModelProtocol {
    var diskCount: DiskCount { self.diskCountDidChange.value }
}



public class DiskCountModel: DiskCountModelProtocol {
    public let diskCountDidChange: ReactiveSwift.Property<DiskCount>


    public init(observing gameStateDidChange: ReactiveSwift.Property<GameState>) {
        self.diskCountDidChange = gameStateDidChange
            .map { gameState in gameState.board.countDisks() }
    }


    public convenience init(observing gameModel: GameModelProtocol) {
        self.init(observing: gameModel.gameModelStateDidChange.map { $0.gameState })
    }
}