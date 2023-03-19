//
//  ComicDetailView.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import Service
import UIKit

final class ComicDetailView: UIView {

    // MARK: - Properties
    private let viewModel: ComicDetailViewModel
    private let imageLoader: ImageLoaderProtocol = Services.make(for: ImageLoaderProtocol.self)

    // MARK: - UI Properties
    private lazy var imageView = UIImageView()

    private lazy var issueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.text = viewModel.issue
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.text = viewModel.price
        return label
    }()

    private lazy var heartButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "heart"), for: .normal)
        button.setImage(.init(systemName: "heart.fill"), for: .selected)
        button.tintColor = .systemRed
        button.backgroundColor = .secondarySystemBackground
        button.isSelected = viewModel.isFavorited
        button.addAction(UIAction { [weak self]  _ in
            guard let self else { return }
            DispatchQueue.main.async {
                button.isSelected = self.viewModel.changeFavoriteStatus(selected: !button.isSelected)
            }
        }, for: .touchUpInside)
        return button
    }()

    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "cart"), for: .normal)
        button.setImage(.init(systemName: "cart.fill"), for: .selected)
        button.backgroundColor = .secondarySystemBackground
        button.isSelected = viewModel.isOnCart
        button.addAction(UIAction { [weak self]  _ in
            guard let self else { return }
            DispatchQueue.main.async {
                button.isSelected = self.viewModel.changeCartStatus(selected: !button.isSelected)
            }
        }, for: .touchUpInside)
        return button
    }()

    private lazy var buyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Buy", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.addAction(UIAction { [weak self]  _ in
            self?.viewModel.proceedToCheckout()
        }, for: .touchUpInside)
        return button
    }()

    // MARK: - Inits
    init(viewModel: ComicDetailViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViewConfiguration()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - ViewCodable
extension ComicDetailView: ViewCodable {
    func buildViewHierarchy() {
        addSubviews(
            imageView,
            issueLabel,
            priceLabel,
            heartButton,
            cartButton,
            buyButton
        )
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),

            issueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            issueLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),

            priceLabel.topAnchor.constraint(equalTo: issueLabel.bottomAnchor, constant: 32),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            priceLabel.bottomAnchor.constraint(equalTo: cartButton.topAnchor, constant: -32),

            heartButton.heightAnchor.constraint(equalToConstant: 56),
            heartButton.widthAnchor.constraint(equalTo: heartButton.heightAnchor),
            heartButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 16),
            heartButton.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -32),

            cartButton.heightAnchor.constraint(equalToConstant: 56),
            cartButton.widthAnchor.constraint(equalTo: cartButton.heightAnchor),
            cartButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -16),
            cartButton.bottomAnchor.constraint(equalTo: heartButton.bottomAnchor),

            buyButton.heightAnchor.constraint(equalToConstant: 56),
            buyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            buyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            buyButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ])
    }

    func setupAdditionalConfiguration() {
        backgroundColor = .systemBackground
        setComicImage()
    }
}

// MARK: - Private methods
private extension ComicDetailView {
    func setComicImage() {
        guard let imageUrl = viewModel.imageUrl else { return }
        imageLoader.downloadImage(imageUrl) { [weak self] result in
            switch result {
            case let .success(success):
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: success)
                }
            case let .failure(failure):
                print(failure.localizedDescription)
            }
        }
    }
}
