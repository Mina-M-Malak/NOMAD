//
//  ThemeManager.swift
//  NOMAD
//
//  Created by Mina Mounir on 6/21/22.
//

import Foundation

class ThemeManager {
    
    static let shared = ThemeManager()
    
    var currentTheme: Theme = DayTheme()
}
