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
    case architecture
    case art
    case attitude
    case beauty
    case best
    case birthday
    case business
    case car
    case change
    case communication
    case computers
    case cool
    case courage
    case dad
    case dating
    case death
    case design
    case dreams
    case education
    case environmental
    case equality
    case experience
    case failure
    case faith
    case family
    case famous
    case fear
    case fitness
    case food
    case forgiveness
    case freedom
    case friendship
    case funny
    case future
    case god
    case good
    case government
    case graduation
    case great
    case happiness
    case health
    case history
    case home
    case hope
    case humor
    case imagination
    case inspirational
    case intelligence
    case jealousy
    case knowledge
    case leadership
    case learning
    case legal
    case life
    case love
    case marriage
    case medical
    case men
    case mom
    case money
    case morning
    case movies
    case success

    var name: String {
        return self.rawValue.capitalized
    }
}
