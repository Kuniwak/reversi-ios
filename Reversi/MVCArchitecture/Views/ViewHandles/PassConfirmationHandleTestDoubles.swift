import ReversiCore
import Reversi
import ReactiveSwift



public class PassConfirmationHandleStub: PassConfirmationHandleProtocol {
    public let passDidAccept = ReactiveSwift.Signal<Void, Never>.empty


    public func confirm() {}
}



public func stub() -> PassConfirmationHandleStub { .init() }
