//
//  NoResultsView.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 18/03/23.
//

import UIKit

final class NoResultsView: UIView {

    // MARK: - Properties
    private let viewModel: NoResultsViewModel

    // MARK: - UI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.text = viewModel.title
        return label
    }()

    private lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .systemBlue
        view.contentMode = .scaleAspectFit
        view.image = viewModel.image
        return view
    }()

    // MARK: - Inits
    init(viewModel: NoResultsViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViewConfiguration()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewCodable
extension NoResultsView: ViewCodable {
    func buildViewHierarchy() {
        addSubviews(
            titleLabel,
            iconView
        )
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 32),

            iconView.heightAnchor.constraint(equalToConstant: 100),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    func setupAdditionalConfiguration() { }
}
