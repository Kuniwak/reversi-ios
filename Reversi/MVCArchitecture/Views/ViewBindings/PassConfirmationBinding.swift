import ReversiCore
import ReactiveSwift



public class PassConfirmationBinding {
    private let gameWithAutomatorsModel: GameWithAutomatorsModelProtocol
    private let passConfirmationHandle: PassConfirmationHandleProtocol
    private let (lifetime, token) = ReactiveSwift.Lifetime.make()


    public init(
        observing gameWithAutomatorsModel: GameWithAutomatorsModelProtocol,
        updating passConfirmationHandle: PassConfirmationHandleProtocol
    ) {
        self.gameWithAutomatorsModel = gameWithAutomatorsModel
        self.passConfirmationHandle = passConfirmationHandle

        gameWithAutomatorsModel.gameWithAutomatorsModelStateDidChange
            .producer
            .take(during: self.lifetime)
            .observe(on: UIScheduler())
            .on(value: { [weak self] state in
                guard state.playerMustPass else { return }
                self?.passConfirmationHandle.confirm()
            })
            .start()
    }
}