//
//  LoginView.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 19/03/23.
//

import UIKit

final class LoginView: UIView {

    // MARK: - Properties
    private let viewModel: LoginViewModel

    // MARK: - UI Properties
    private let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.alpha = 0
        return view
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        spinner.alpha = 0
        return spinner
    }()

    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "M A R V E L"
        label.backgroundColor = .systemRed
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 36, weight: .bold)
        return label
    }()

    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.delegate = self
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .continue
        textField.becomeFirstResponder()
        textField.borderStyle = .roundedRect
        textField.addAction(UIAction { [weak self] _ in
            self?.viewModel.updateEmail(textField.text ?? "")
        }, for: .editingChanged)
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.delegate = self
        textField.returnKeyType = .done
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.addAction(UIAction { [weak self] _ in
            self?.viewModel.updatePassword(textField.text ?? "")
        }, for: .editingChanged)
        return textField
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.addAction(UIAction { [weak self] _ in
            self?.endEditing(true)
            self?.viewModel.login()
        }, for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    // MARK: - Inits
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViewConfiguration()
        self.viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewCodable
extension LoginView: ViewCodable {
    func buildViewHierarchy() {
        addSubviews(
            logoLabel,
            emailTextField,
            passwordTextField,
            loginButton,
            loadingView,
            spinner
        )
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            logoLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            logoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            logoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            logoLabel.heightAnchor.constraint(equalToConstant: 80),

            emailTextField.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),

            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.heightAnchor.constraint(equalToConstant: 56),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),

            spinner.leadingAnchor.constraint(equalTo: leadingAnchor),
            spinner.trailingAnchor.constraint(equalTo: trailingAnchor),
            spinner.topAnchor.constraint(equalTo: topAnchor),
            spinner.bottomAnchor.constraint(equalTo: bottomAnchor),

            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingView.topAnchor.constraint(equalTo: topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupAdditionalConfiguration() { }
}

// MARK: - UITextFieldDelegate
extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            if loginButton.isEnabled {
                viewModel.login()
            }
        default:
            break
        }
        return true
    }
}

// MARK: - LoginViewModel
extension LoginView: LoginViewModelDelegate {
    func updatedButtonIsEnabled(_ isEnabled: Bool) {
        loginButton.isEnabled = isEnabled
    }

    func changedState(_ state: LoginViewModel.State) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            switch state {
            case .idle:
                self?.loadingView.alpha = 0
                self?.spinner.alpha = 0
            case .fetching:
                self?.loadingView.alpha = 0.75
                self?.spinner.alpha = 1
            }
        }
    }
}
