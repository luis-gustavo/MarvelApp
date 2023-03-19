//
//  ComicCollectionViewDataSource.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 18/03/23.
//

import UIKit

protocol ComicCollectionViewDataSourceProtocol: AnyObject {
    func didSelectComic(at index: Int)
    func shouldFetchMoreData()
    func showLoadMore() -> Bool
    func isLoadingMore() -> Bool
    func cellViewModels() -> [ComicCollectionViewCellViewModel]
}

final class ComicCollectionViewDataSource: NSObject {

    // MARK: - Properties
    weak var delegate: ComicCollectionViewDataSourceProtocol?
}

// MARK: - UICollectionViewDataSource
extension ComicCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        (delegate?.cellViewModels() ?? []).count
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

        let cellViewModel = (delegate?.cellViewModels() ?? [])[indexPath.item]
        cell.configure(with: cellViewModel)
        return cell
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
}

// MARK: - UICollectionViewDataSource
extension ComicCollectionViewDataSource: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectComic(at: indexPath.item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ComicCollectionViewDataSource: UICollectionViewDelegateFlowLayout {
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
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        guard delegate?.showLoadMore() ?? false else { return .zero }
        return .init(width: collectionView.frame.width, height: 100)
    }
}

// MARK: - UIScrollViewDelegate
extension ComicCollectionViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard delegate?.showLoadMore() ?? false,
              !(delegate?.isLoadingMore() ?? false) else { return }
        let yOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewFixedHeight = scrollView.frame.size.height

        if yOffset >= (contentHeight - scrollViewFixedHeight - 120) {
            delegate?.shouldFetchMoreData()
        }
    }
}
