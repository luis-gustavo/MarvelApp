//
//  CharacterListView.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 16/03/23.
//

import UIKit

final class ComicListView: UIView {

    // MARK: - Properties
    private let viewModel: ComicListViewModel

    // MARK: - UI Properties
    private let spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.startAnimating()
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isHidden = true
        view.alpha = 0
        view.allowsSelection = true
        view.allowsMultipleSelection = false
        view.register(
            ComicCollectionViewCell.self,
            forCellWithReuseIdentifier: ComicCollectionViewCell.identifier
        )
        view.register(
            FooterLoadingCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: FooterLoadingCollectionReusableView.identifier
        )
        view.delegate = self
        view.dataSource = self
        return view
    }()

    // MARK: - Inits
    init(viewModel: ComicListViewModel) {
        self.viewModel = viewModel
        self.viewModel.fetchComics()
        super.init(frame: .zero)
        setupViewConfiguration()
        self.viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewCodable
extension ComicListView: ViewCodable {
    func buildViewHierarchy() {
        addSubviews(
            collectionView,
            spinner
        )
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),

            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupAdditionalConfiguration() { }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension ComicListView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.cellViewModels.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ComicCollectionViewCell.identifier,
            for: indexPath
        ) as? ComicCollectionViewCell else {
            return .init()
        }
        let cellViewModel = viewModel.cellViewModels[indexPath.item]
        cell.configure(with: cellViewModel)
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let bounds = collectionView.bounds
        let width = (bounds.width - 42) / 2
        return .init(
            width: width,
            height: width * 1.5
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else {
            return UICollectionReusableView()
        }

        let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: FooterLoadingCollectionReusableView.identifier,
            for: indexPath)

        return footer
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        guard viewModel.showLoadMore else {
            return .zero
        }
        return .init(width: collectionView.frame.width, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard viewModel.showLoadMore,
              !viewModel.isLoadingMore else { return }
        let yOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewFixedHeight = scrollView.frame.size.height

        if yOffset >= (contentHeight - scrollViewFixedHeight - 120) {
            viewModel.fetchAdditionalComics()
        }
    }
}

// MARK: - ComicListViewModelDelegate
extension ComicListView: ComicListViewModelDelegate {
    func loadedInitialComics() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.collectionView.alpha = 1
        }
    }

    func loadedMoreComics(withOriginal originalCount: Int, andNewCount newCount: Int) {
        let total = originalCount + newCount
        let startingIndex = total - newCount
        let indexPathToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap {
            return IndexPath(row: $0, section: 0)
        }
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: indexPathToAdd)
        }
    }
}
