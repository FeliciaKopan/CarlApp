//
//  UiViewExtension.swift
//  CarlApp
//
//  Created by Felicia Alamorean on 09.09.2024.
//

import UIKit

extension UIView {
    func addSubview(_ other: UIView, constraints: [NSLayoutConstraint]) {
        addSubview(other)
        other.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }
    
    func addSubview(_ other: UIView, withEdgeInsets edgeInsets: UIEdgeInsets) {
        addSubview(other, constraints: [
            other.leadingAnchor.constraint(equalTo: leadingAnchor, constant: edgeInsets.left),
            other.topAnchor.constraint(equalTo: topAnchor, constant: edgeInsets.top),
            other.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -edgeInsets.right),
            other.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -edgeInsets.bottom)
        ])
    }
}
