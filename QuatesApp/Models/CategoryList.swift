//
//  CategoryList.swift
//  QuatesApp
//
//  Created by Apple M1 on 18.06.2024.
//

import Foundation

enum CategoryList: String, CaseIterable {
    case age
    case alone
    case amazing
    case anger
    case birthday
    case business
    case car
    case fitness
    case food
    case friendship
    case funny
    case future
    case god
    case government
    case graduation
    case great
    case happiness
    case hope
    case humor
    case intelligence
    case leadership
    case life
    case love
    case money
    case morning
    case movies

    var name: String {
        return self.rawValue.capitalized
    }
}
