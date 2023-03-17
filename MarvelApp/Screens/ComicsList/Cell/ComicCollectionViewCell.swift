//
//  CharacterCollectionViewCell.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 16/03/23.
//

import UIKit

final class ComicCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Properties
    private let imageView = UIImageView()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 18,
            weight: .medium
        )
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
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

    // MARK: - prepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
    }
}

// MARK: - ViewCodable
extension ComicCollectionViewCell: ViewCodable {
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

            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func setupAdditionalConfiguration() {
        contentView.backgroundColor = .secondarySystemBackground
    }
}

// MARK: - Internal methods
extension ComicCollectionViewCell {
    func configure(with viewModel: ComicCollectionViewCellViewModel) {
        nameLabel.text = viewModel.title
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
