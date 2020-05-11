import UIKit
import UIKitTestable
import ReactiveSwift



public protocol ResetConfirmationHandleProtocol {
    var resetDidAccept: ReactiveSwift.Signal<Bool, Never> { get }
}



public class ResetConfirmationHandle: ResetConfirmationHandleProtocol {
    private let confirmationViewHandle: UserConfirmationViewHandle<Bool>
    private let button: UIButton


    public let resetDidAccept: ReactiveSwift.Signal<Bool, Never>


    public init(handle button: UIButton, willPresentOn modalPresenter: UIKitTestable.ModalPresenterProtocol) {
        self.button = button

        let confirmationViewHandle = UserConfirmationViewHandle(
            title: "Confirmation",
            message: "Do you really want to reset the game?",
            preferredStyle: .alert,
            actions: [
                (title: "Cancel", style: .cancel, false),
                // BUG12: Unexpectedly use false instead of true.
                (title: "OK", style: .default, true),
            ],
            willPresentOn: modalPresenter
        )
        self.confirmationViewHandle = confirmationViewHandle
        self.resetDidAccept = self.confirmationViewHandle.userDidConfirm

        button.addTarget(self, action: #selector(self.confirm(_:)), for: .touchUpInside)
    }


    @objc private func confirm(_ sender: Any) {
        self.confirmationViewHandle.confirm()
    }
}
