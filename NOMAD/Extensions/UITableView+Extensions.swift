//
//  UITableView+Extensions.swift
//  NOMAD
//
//  Created by Mina Mounir on 6/17/22.
//

import UIKit.UITableView

extension UITableView {
    
    func register<T: UITableViewCell>(_: T.Type, reuseIdentifier: String? = nil) {
        register(T.self, forCellReuseIdentifier: reuseIdentifier ?? String(describing: T.self))
    }
    
    func register<T: UITableViewCell>(nib : T.Type, reuseIdentifier: String? = nil) {
        register(UINib(nibName: reuseIdentifier ?? String(describing: T.self), bundle: nil),
                 forCellReuseIdentifier:  reuseIdentifier ?? String(describing: T.self))
    }
    
    func register<T: UITableViewHeaderFooterView>(headerFooter: T.Type, reuseIdentifier: String? = nil) {
        register(T.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier ?? String(describing: T.self))
    }
    
    func register<T: UITableViewHeaderFooterView>(headerFooterNib: T.Type, reuseIdentifier: String? = nil) {
        register(UINib(nibName: reuseIdentifier ?? String(describing: T.self), bundle: nil),
                 forHeaderFooterViewReuseIdentifier:  reuseIdentifier ?? String(describing: T.self))
    }
    
    func dequeue<T: UITableViewCell>(cell: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Could not dequeue cell with type \(T.self)")
        }
        
        return cell
    }
    
    func dequeue<T: UITableViewHeaderFooterView>(headerFooter: T.Type) -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Could not dequeue cell with type \(T.self)")
        }
        
        return view
    }
    
    func dequeueCell(reuseIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        return dequeueReusableCell(
            withIdentifier: identifier,
            for: indexPath
        )
    }
}
