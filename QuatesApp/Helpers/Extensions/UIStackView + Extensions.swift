//
//  UIStackView + Extensions.swift
//  QuatesApp
//
//  Created by Apple M1 on 21.06.2024.
//

import UIKit

extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis, spacing: CGFloat, distribution: Distribution = .fill, isHidden: Bool = false) {
        self.init()
        
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.isHidden = isHidden
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
