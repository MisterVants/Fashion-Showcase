//
//  UIView+Extension.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 05/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import UIKit

/*
 Constrain an UI element directly inside another UIView or UILayoutGuides area. When working with a constraint-based
 layout programatically, this extensions is useful to easily add content views to view controllers or scroll views.
 Don't forget to define the view hierarchy and add all subviews before adding the constraints!!
 */
extension UIView {
    
    /**
     Constraints the UI element inside a given UIView with top, bottom, leading and trailing constraints.
     
     - Parameters:
     - view: The UIView that will receive the constrained view.
     - value: The inset value for the margins.
     - activate: Informs if the constraints should be activated immediatelly. Default is true.
     - Returns: An array containing all constraints created. Discardable.
     */
    @discardableResult
    func constraintInside(_ view: UIView,
                          insetBy value: CGFloat,
                          activate: Bool = true) -> [NSLayoutConstraint] {
        return constraintInside(view, top: value, bottom: value, leading: value, trailing: value, activate: activate)
    }
    
    /**
     Constraints the UI element inside a given UIView with top, bottom, leading and trailing constraints.
     
     - Parameters:
     - view: The UIView that will receive the constrained view.
     - top: The top margin inset value.
     - bottom: The bottom margin inset value.
     - leading: The leading margin inset value.
     - trailing: The trailing margin inset value.
     - activate: Informs if the constraints should be activated immediatelly. Default is true.
     - Returns: An array containing all constraints created. Discardable.
     */
    @discardableResult
    func constraintInside(_ view: UIView,
                          top: CGFloat = 0,
                          bottom: CGFloat = 0,
                          leading: CGFloat = 0,
                          trailing: CGFloat = 0,
                          activate: Bool = true) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        let constraints = [self.topAnchor.constraint(equalTo: view.topAnchor, constant: top),
                           self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottom),
                           self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading),
                           self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -trailing)]
        constraints.forEach { $0.isActive = activate }
        return constraints
    }
    
    /**
     Constraints the UI element inside a given UILayoutGuides area with top, bottom, leading and trailing constraints.
     
     - Parameters:
     - view: The UIView that will receive the constrained view.
     - value: The inset value for the margins.
     - activate: Informs if the constraints should be activated immediatelly. Default is true.
     - Returns: An array containing all constraints created. Discardable.
     */
    @discardableResult
    func constraintInside(_ layoutGuides: UILayoutGuide,
                          insetBy value: CGFloat,
                          activate: Bool = true) -> [NSLayoutConstraint] {
        return constraintInside(layoutGuides, top: value, bottom: value, leading: value, trailing: value, activate: activate)
    }
    
    /**
     Constraints the UI element inside a given UILayoutGuides area with top, bottom, leading and trailing constraints.
     
     - Parameters:
     - layoutGuides: The UILayoutGuides that will receive the constrained view.
     - top: The top margin inset value.
     - bottom: The bottom margin inset value.
     - leading: The leading margin inset value.
     - trailing: The trailing margin inset value.
     - activate: Informs if the constraints should be activated immediatelly. Default is true.
     - Returns: An array containing all constraints created. Discardable.
     */
    @discardableResult
    func constraintInside(_ layoutGuides: UILayoutGuide,
                          top: CGFloat = 0,
                          bottom: CGFloat = 0,
                          leading: CGFloat = 0,
                          trailing: CGFloat = 0,
                          activate: Bool = true) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        let constraints = [self.topAnchor.constraint(equalTo: layoutGuides.topAnchor, constant: top),
                           self.bottomAnchor.constraint(equalTo: layoutGuides.bottomAnchor, constant: -bottom),
                           self.leadingAnchor.constraint(equalTo: layoutGuides.leadingAnchor, constant: leading),
                           self.trailingAnchor.constraint(equalTo: layoutGuides.trailingAnchor, constant: -trailing)]
        constraints.forEach { $0.isActive = activate }
        return constraints
    }
}
