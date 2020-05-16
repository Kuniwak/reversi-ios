import ReversiCore
import Reversi
import ReactiveSwift



public class GameAutomatorControlHandleStub: GameAutomatorControlHandleProtocol {
    public let availabilitiesDidChange = ReactiveSwift.Signal<GameAutomatorAvailabilities, Never>.empty


    public func apply(availabilities: GameAutomatorAvailabilities) {}
}



public func stub() -> GameAutomatorControlHandleStub { .init() }
