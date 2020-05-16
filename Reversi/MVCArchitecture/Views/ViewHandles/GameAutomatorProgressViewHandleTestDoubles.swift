import ReversiCore
import Reversi



public class GameAutomatorProgressViewHandleStub: GameAutomatorProgressViewHandleProtocol {
    public func apply(inProgress: Turn?) {}
}



public func stub() -> GameAutomatorProgressViewHandleStub { .init() }
