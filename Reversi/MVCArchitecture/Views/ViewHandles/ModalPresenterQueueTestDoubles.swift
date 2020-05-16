import Reversi



public class ModalPresenterQueueStub: ModalPresenterQueueProtocol {
    public func enqueue(task: ModalPresenterTask) {}


    public func viewDidAppear() {}


    public func viewWillDisappear() {}
}



public func stub() -> ModalPresenterQueueStub { .init() }
