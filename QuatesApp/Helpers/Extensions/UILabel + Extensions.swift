//
//  UILabel + Extensions.swift
//  QuatesApp
//
//  Created by Apple M1 on 21.06.2024.
//

import UIKit

extension UILabel {
    convenience init(text: String = "", textColor: UIColor = .label, alignment: NSTextAlignment = .left, font: UIFont?, lines: Int = 1) {
        self.init()
        
        self.text = text
        self.textColor = textColor
        self.backgroundColor = .clear
        self.textAlignment = alignment
        self.numberOfLines = lines
        self.font = font
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
