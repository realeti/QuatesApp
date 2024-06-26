//
//  FavoritesViewModel.swift
//  QuatesApp
//
//  Created by Apple M1 on 25.06.2024.
//

import Foundation

protocol FavoritesModeling {
    var sectionType: SectionType { get }
    var quotes: [Quote] { get }
    var jokes: [Joke] { get }
    var chuckJokes: [ChuckNorrisJoke] { get }
}

final class FavoritesViewModel: FavoritesModeling {
    var sectionType: SectionType = .quote
    var quotes: [Quote] = []
    var jokes: [Joke] = []
    var chuckJokes: [ChuckNorrisJoke] = []
}
