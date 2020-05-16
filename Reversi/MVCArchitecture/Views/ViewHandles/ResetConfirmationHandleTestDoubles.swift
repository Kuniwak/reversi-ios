import Reversi
import ReactiveSwift



public class ResetConfirmationHandleStub: ResetConfirmationHandleProtocol {
    public let resetDidAccept = ReactiveSwift.Signal<Bool, Never>.empty
}



public func stub() -> ResetConfirmationHandleStub { .init() }
