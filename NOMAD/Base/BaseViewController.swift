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
    
    //Setup View UI
    func setupUI(){}
    
    func registerCells(){}
}

