//
//  md5.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 16/03/23.
//

import CryptoKit

func md5(_ string: String) -> String {
    let computed = Insecure.MD5.hash(data: string.data(using: .utf8)!)
    return computed.map { String(format: "%02hhx", $0) }.joined()
}
