//
//  FooterLoadingCollectionReusableView.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import UIKit

final class FooterLoadingCollectionReusableView: UICollectionReusableView {

    // MARK: - Properties
    private let spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.startAnimating()
        return view
    }()

    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewConfiguration()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - ViewCodable
extension FooterLoadingCollectionReusableView: ViewCodable {
    func buildViewHierarchy() {
        addSubviews(
            spinner
        )
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    func setupAdditionalConfiguration() {
        backgroundColor = .systemBackground
    }
}
