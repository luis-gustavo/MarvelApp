//
//  LoginViewModel.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 19/03/23.
//

import Foundation
import Service

protocol LoginViewModelDelegate: AnyObject {
    func updatedButtonIsEnabled(_ isEnabled: Bool)
    func changedState(_ state: LoginViewModel.State)
}

final class LoginViewModel {

    // MARK: - State
    enum State {
        case idle, fetching
    }

    // MARK: - Properties
    weak var delegate: LoginViewModelDelegate?
    var isButtonEnabled: Bool = false {
        didSet {
            if oldValue != isButtonEnabled {
                delegate?.updatedButtonIsEnabled(isButtonEnabled)
            }
        }
    }
    private var email: String = "" {
        didSet {
            isButtonEnabled = email.isValidEmail && !password.isEmpty
        }
    }
    private var password: String = "" {
        didSet {
            isButtonEnabled = email.isValidEmail && !password.isEmpty
        }
    }
    private let loginProvider: LoginProviderProtocol = Services.make(for: LoginProviderProtocol.self)
    private let router: LoginRouterProtocol
    private var state: State = .idle {
        didSet {
            delegate?.changedState(state)
        }
    }

    // MARK: - Init
    init(router: LoginRouterProtocol) {
        self.router = router
    }
}

// MARK: - Internal methods
extension LoginViewModel {
    func updateEmail(_ email: String) {
        self.email = email
    }

    func updatePassword(_ password: String) {
        self.password = password
    }

    func login() {
        state = .fetching
        loginProvider.login(with: email, and: password) { [weak self] result in
            switch result {
            case .success:
                self?.router.showMainView()
            case let .failure(error):
                self?.state = .idle
                print(error.localizedDescription)
            }
        }
    }
}
