//
//  Theme.swift
//  NOMAD
//
//  Created by Mina Mounir on 6/21/22.
//

import UIKit.UIColor

@objc protocol Theme {
    
    var primaryColor: UIColor { get }
    var secondaryColor: UIColor { get }
    
    var darkRedColor: UIColor { get }
    var navigationBarTint: UIColor { get }
    
    var background: UIColor { get }
}
