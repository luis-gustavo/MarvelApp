//
//  UIView+addSubviews.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 16/03/23.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
}
