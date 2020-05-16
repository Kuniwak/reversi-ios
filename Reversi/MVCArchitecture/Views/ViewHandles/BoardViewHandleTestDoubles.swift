import Reversi
import ReversiCore
import ReactiveSwift



public class BoardViewHandleStub: BoardViewHandleProtocol {
    public let coordinateDidSelect = ReactiveSwift.Signal<Coordinate, Never>.empty


    public func apply(by request: ReversiCore.BoardAnimationRequest) {}
}



public func stub() -> BoardViewHandleStub { .init() }



public class BoardAnimationViewHandleStub: BoardAnimationHandleProtocol {
    public let animationDidComplete = ReactiveSwift.Signal<BoardAnimationRequest, Never>.empty
}



public func stub() -> BoardAnimationViewHandleStub { .init() }