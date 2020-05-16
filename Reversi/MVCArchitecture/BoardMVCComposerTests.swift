import XCTest
import Foundation
import Reversi



class BoardMVCComposerTests: XCTestCase {
    func testInit() {
        _ = BoardMVCComposer(
            userDefaults: UserDefaults(),
            boardViewHandle: stub(),
            boardAnimationHandle: stub(),
            gameAutomatorProgressViewHandle: stub(),
            gameAutomatorControlHandle: stub(),
            passConfirmationViewHandle: stub(),
            resetConfirmationViewHandle: stub(),
            diskCountViewHandle: stub(),
            turnMessageViewHandle: stub()
        )
    }
}
