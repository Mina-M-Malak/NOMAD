//
//  UIViewController+Extensions.swift
//  NOMAD
//
//  Created by Mina Mounir on 6/17/22.
//

import UIKit.UIViewController

extension UIViewController{
    enum Actiontype{
        case Back
        case Dismiss
    }
    
    func showAlert(title: String? = "",message : String? = nil , alertAction: Actiontype? = nil,handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            DispatchQueue.main.async {
                alert.dismiss(animated: true, completion: nil)
                
                switch alertAction{
                case .Back:
                    self.navigationController?.popViewController(animated: true)
                case .Dismiss:
                    self.dismiss(animated: true, completion: nil)
                case .none:
                    handler?(action)
                }
            }
        }))
        alert.view.tintColor = ThemeManager.shared.currentTheme.primaryColor
        self.present(alert, animated: true, completion: nil)
    }
}
