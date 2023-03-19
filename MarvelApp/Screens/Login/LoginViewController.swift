//
//  LoginViewController.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 19/03/23.
//

import UIKit

final class LoginViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: LoginViewModel

    // MARK: - UI Properties
    private lazy var loginView: LoginView = {
        let view = LoginView(viewModel: viewModel)
        return view
    }()

    // MARK: - Inits
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - loadView
    override func loadView() {
        view = loginView
    }
}
