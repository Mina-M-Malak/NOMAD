//
//  CartViewController.swift
//  NOMAD
//
//  Created by Mina Mounir on 6/17/22.
//

import UIKit
import Combine

class CartViewController: BaseViewController {
    
    @IBOutlet weak var cartTableView: UITableView!
    
    private var observers: [AnyCancellable] = []
    private var viewModel = CartViewModel()
    private var products: [Product] = []{
        didSet{
            cartTableView.reloadData()
            cartTableView.tableFooterView = tableViewFooter()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubscribers()
        viewModel.fetchData()
    }
    
    //Setup View UI
    override func setupUI(){
        super.setupUI()
        
        title = "Cart"
        cartTableView.tableFooterView = tableViewFooter()
        cartTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    //Register TableView Cell
    override func registerCells() {
        cartTableView.register(nib: ProductTableViewCell.self)
    }
    
    //setup colors
    override func setupViewColors(theme: Theme) {
        super.setupViewColors(theme: theme)
        view.backgroundColor = theme.background
        cartTableView.reloadData()
        cartTableView.tableFooterView = tableViewFooter()
        cartTableView.separatorColor = theme.primaryColor
    }
    
    private func tableViewFooter() -> UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: cartTableView.frame.size.width, height: 50))
        let label = UILabel(frame: CGRect(x: 16, y: 8, width: cartTableView.frame.size.width - 32, height: 30))
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = ThemeManager.shared.currentTheme.primaryColor
        label.textAlignment = .center
        label.text = "Total: " + "\(viewModel.getProductsPrice())" + " " + "EGP"
        footerView.addSubview(label)
        footerView.backgroundColor = ThemeManager.shared.currentTheme.background
        return footerView
    }
    
    //set subscribers
    private func addSubscribers(){
        viewModel.$result.receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] (result) in
                guard let strongSelf = self else { return }
                switch result{
                case .empty:
                    strongSelf.products = []
                case .success(let products):
                    strongSelf.products = products
                case .idle:
                    break
                }
            }).store(in: &observers)
    }
    
    //Delete Item
    private func deleteitem(product: Product,indexPath: IndexPath){
        cartTableView.performBatchUpdates {
            products.remove(at: indexPath.row)
            cartTableView.deleteRows(at: [indexPath], with: .fade)
        } completion: { [weak self] (_) in
            self?.viewModel.deleteProduct(product: product)
        }
    }
}

//MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if products.isEmpty{
            tableView.setEmptyView(title: "No products found", message: "Please add items to the cart", image: UIImage(systemName: "cart"))
        }
        else{
            tableView.restore()
        }
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: ProductTableViewCell.self, for: indexPath)
        cell.setupColors()
        cell.setData(product: products[indexPath.row],isProductCart: true)
        cell.didChangeQuantity = { [weak self] (isPlus) in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.didChangeProductQuantity(product: strongSelf.products[indexPath.row],isPlus: isPlus)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { [weak self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            guard let self = self else { return }
            self.deleteitem(product: self.products[indexPath.row], indexPath: indexPath)
            success(true)
        })
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = UIColor(red: 255/256, green: 20/256, blue: 76/256, alpha: 1.0)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
