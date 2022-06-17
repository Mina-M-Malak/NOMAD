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
    
    func setEmptyView(title: String, message: String,image: UIImage? = nil) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        imageView.image = image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        emptyView.addSubview(imageView)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -8).isActive = true
        imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
            self.backgroundView = nil
            self.separatorStyle = .singleLine
        }
}
