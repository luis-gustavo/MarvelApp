//
//  String+isValidEmail.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 19/03/23.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        guard !isEmpty else { return false }
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: self)
    }
}
