//
//  UIView + Extensions.swift
//  QuatesApp
//
//  Created by Apple M1 on 21.06.2024.
//

import UIKit

extension UIView {
    func makeShadow(color: UIColor) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 4
    }
}
