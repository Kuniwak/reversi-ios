import ReversiCore
import Reversi


public class DiskCountViewHandleStub: DiskCountViewHandleProtocol {
    public func apply(diskCount: DiskCount) {}
}


public func stub() -> DiskCountViewHandleStub { .init() }
