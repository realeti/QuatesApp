//
//  UIView + Extensions.swift
//  QuatesApp
//
//  Created by Apple M1 on 21.06.2024.
//

import UIKit

extension UIView {
    func makeShadow(color: UIColor) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 4
    }
}
