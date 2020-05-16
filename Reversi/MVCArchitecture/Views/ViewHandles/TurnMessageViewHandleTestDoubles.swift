import Reversi



public class TurnMessageViewHandleStub: TurnMessageViewHandleProtocol {
    public func apply(message: TurnMessage) {}
}



public func stub() -> TurnMessageViewHandleStub { .init() }
