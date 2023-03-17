//
//  CharacterCollectionViewCell.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 16/03/23.
//

import UIKit

final class CharacterCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Properties
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 18,
            weight: .medium
        )
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViewConfiguration()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewCodable
extension CharacterCollectionViewCell: ViewCodable {
    func buildViewHierarchy() {
        contentView.addSubviews(
            imageView,
            nameLabel
        )
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func setupAdditionalConfiguration() {
        contentView.backgroundColor = .secondarySystemBackground
    }
}

// MARK: - Internal methods
extension CharacterCollectionViewCell {
    func configure(with viewModel: CharacterCollectionViewCellViewModel) {
        nameLabel.text = viewModel.name
        viewModel.fetchImage { [weak self] result in
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.imageView.image = image
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
