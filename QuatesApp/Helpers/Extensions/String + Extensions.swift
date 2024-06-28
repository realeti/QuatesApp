//
//  String + Extensions.swift
//  QuatesApp
//
//  Created by Apple M1 on 27.06.2024.
//

import Foundation
import CryptoKit

extension String {
    func hashed() -> String {
        let data = Data(self.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}
