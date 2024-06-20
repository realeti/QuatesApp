//
//  QuoteViewController.swift
//  QuatesApp
//
//  Created by Apple M1 on 18.06.2024.
//

import UIKit
import SnapKit

class QuoteViewController: UIViewController {
    
    // MARK: - UI
    
    
    // MARK: - Public Properties
    var quote: Quote?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        view.backgroundColor = .systemRed
    }
    
    // MARK: - Set Views
    
    private func setupUI() {
        displayQuote()
    }
    
    private func displayQuote() {
        guard let quote else { return }
        
        print("Quote: \(quote.quote), Author: \(quote.author)")
    }
}

extension QuoteViewController {
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        
    }
}
