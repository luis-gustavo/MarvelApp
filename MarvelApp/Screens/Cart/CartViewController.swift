//
//  CartViewController.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 18/03/23.
//

import UIKit

final class CartViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: CartViewModel

    // MARK: - UI Properties
    private lazy var cartView: CartView = {
        let view = CartView(viewModel: viewModel)
        view.delegate = self
        return view
    }()

    // MARK: - Inits
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - loadView
    override func loadView() {
        view = cartView
        title = TabBarPage.cart.title
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchComicsFromCart()
    }
}

// MARK: - CartViewDelegate
extension CartViewController: CartViewDelegate {
    func didSelectComic(at position: Int) {
        viewModel.showComicDetail(at: position)
    }
}
