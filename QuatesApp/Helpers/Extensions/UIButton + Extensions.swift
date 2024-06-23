//
//  UIButton + Extensions.swift
//  QuatesApp
//
//  Created by Apple M1 on 23.06.2024.
//

import UIKit

extension UIButton {
    func customizeTitle(title: String, font: UIFont?, foregroundColor: UIColor, shadowColor: UIColor = .clear, shadowRadius: CGFloat = 0) {
        let shadow = NSShadow()
        shadow.shadowColor = shadowColor
        shadow.shadowBlurRadius = shadowRadius
        
        let attributes: [NSAttributedString.Key : Any] = [
            .font: font ?? UIFont.systemFont(ofSize: 18),
            .foregroundColor: foregroundColor,
            .shadow: shadow
        ]
        
        let attributesString = NSAttributedString(string: title, attributes: attributes)
        self.setAttributedTitle(attributesString, for: .normal)
    }
}
