//
//  BaseViewController.swift
//  NOMAD
//
//  Created by Mina Mounir on 6/16/22.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        registerCells()
    }
    
    func customizeNavigationBar() {
        let theme = ThemeManager.shared.currentTheme
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = theme.navigationBarTint
        let appearance = navigationController?.navigationBar.standardAppearance
        appearance?.configureWithOpaqueBackground()
        appearance?.backgroundColor = theme.darkRedColor
        appearance?.shadowImage = nil
        appearance?.shadowColor = nil
        appearance?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance!
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    @objc func setupViewColors(theme: Theme) {
        customizeNavigationBar()
    }
    
    //Setup View UI
    func setupUI(){
        ThemeManager.shared.currentTheme = (traitCollection.userInterfaceStyle == .dark) ? NightTheme() : DayTheme()
        setupViewColors(theme: ThemeManager.shared.currentTheme)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupViewColors),
                                               name: Notification.Name("ThemeDidChanged"),
                                               object: nil)
        
        customizeNavigationBar()
    }
    
    func registerCells(){}
}

extension BaseViewController: UIGestureRecognizerDelegate {}

extension BaseViewController {
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                ThemeManager.shared.currentTheme = NightTheme()
            } else {
                ThemeManager.shared.currentTheme = DayTheme()
            }
            setupViewColors(theme: ThemeManager.shared.currentTheme)
        }
        
    }
}
