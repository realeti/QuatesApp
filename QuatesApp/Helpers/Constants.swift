//
//  Constants.swift
//  QuatesApp
//
//  Created by Apple M1 on 18.06.2024.
//

import Foundation

struct K {
    
    // MARK: - TabBar
    static let homeTabTitle = "Home"
    static let favoritesTabTitle = "Favorites"
    
    // MARK: - Segment Control
    static let quoteTitle = "Quotes"
    static let jokesTitle = "Jokes"
    static let chuckNorrisTitle = "Chuck Norris"
    
    // MARK: - Labels
    static let searchPlaceholder = "Search for category"
    static let fetchButtonQuoteTitle = "Get quote!"
    static let fetchButtonJokeTitle = "Get joke!"
    static let fetchButtonChuckTitle = "Get joke!"
    static let randomQuote = "Random quote"
    static let randomJoke = "Random joke"
    static let notFound = "Nothing found :("
    static let authorRandomJoke = "Random joke"
    static let authorChuckNorrisJoke = "Chuck Norris joke"
    
    // MARK: - Buttons
    static let systemCloseButton = "xmark.circle.fill"
    
    // MARK: - Section title
    static let quoteSectionTitle = "Categories of\nquotes"
    static let jokesSectionTitle = "Get a random\nwonderful joke"
    static let chuckSectionTitle = "Get a joke from\nChuck Norris"
    
    // MARK: - Table View
    static let quoteReuseIdentifier = "quoteCell"
    static let favoriteQuotes = "Favorite quotes"
    static let favoriteJokes = "Favorite jokes"
    static let favoriteChuckNorris = "Favorite C.N. jokes"
    static let favoriteDelete = "Delete"
    static let favoriteDeleteMessage = "Are you sure?"
    
    // MARK: - Alert
    static let alertError = "Error"
    static let alertOk = "OK"
    static let alertYes = "Yes"
    static let alertNo = "No"
    static let alertCancel = "Cancel"
    
    // MARK: - Fonts
    static let fontMontserrat400 = "Montserrat-Medium"
    static let fontPTSerif400 = "PTSerif-Regular"
    static let fontPTSerifItalic = "PTSerif-Italic"
    
    // MARK: - Core Data
    static let coreDataModelName = "QuoteData"
    
    private init() {}
}
