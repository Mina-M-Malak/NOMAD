//
//  ProductListViewController.swift
//  NOMAD
//
//  Created by Mina Mounir on 6/17/22.
//

import UIKit
import Combine

class ProductListViewController: BaseViewController {
    
    @IBOutlet weak var productListTableView: UITableView!
    
    private var observers: [AnyCancellable] = []
    
    private var refreshControl = UIRefreshControl()
    private var viewModel = ProductListViewModel()
    private var searchText: String = ""{
        didSet{
            viewModel.filterData(searchText: searchText)
        }
    }
    private var products: [Product] = []{
        didSet{
            productListTableView.reloadData()
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
        
        title = "Product List"
        productListTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: productListTableView.frame.size.width, height: 1))
        productListTableView.refreshControl  = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresher), for: .valueChanged)
        productListTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    //setup colors
    override func setupViewColors(theme: Theme) {
        super.setupViewColors(theme: theme)
        view.backgroundColor = theme.background
        productListTableView.separatorColor = theme.primaryColor
        productListTableView.reloadData()
    }
    
    //Register TableView Cell
    override func registerCells() {
        productListTableView.register(nib: ProductTableViewCell.self)
    }
    
    //set subscribers
    private func addSubscribers(){
        viewModel.$result.receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] (result) in
                guard let strongSelf = self else { return }
                switch result{
                case .idle:
                    break
                case .loading:
                    strongSelf.handleRefreshControl(true)
                case .success(let produts):
                    strongSelf.handleRefreshControl(false)
                    strongSelf.products = produts
                case .failure(let error):
                    strongSelf.handleRefreshControl(false)
                    strongSelf.showAlert(title: "Error", message: error)
                }
            }).store(in: &observers)
    }
    
    @objc private func handleRefresher() {
        viewModel.fetchData()
    }
    
    @objc private func handleRefreshControl(_ isRefreshing:Bool) {
        if isRefreshing {
            refreshControl.beginRefreshing()
            productListTableView.contentOffset = CGPoint(x:0, y:-self.refreshControl.frame.size.height)
        } else {
            productListTableView.setContentOffset(.zero, animated: true)
            refreshControl.endRefreshing()
        }
    }
    
    @IBAction func searchAction(_ sender: UIBarButtonItem) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = ThemeManager.shared.currentTheme.darkRedColor
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.searchTextField.tintColor = .black
        searchController.searchBar.searchTextField.textColor = .black
        searchController.searchBar.placeholder = "Search"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Cancel"
        if (!searchText.isEmpty){
            searchController.searchBar.text = searchText
        }
        searchController.hidesNavigationBarDuringPresentation = false
        self.present(searchController,animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource
extension ProductListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: ProductTableViewCell.self, for: indexPath)
        cell.setupColors()
        cell.setData(product: products[indexPath.row])
        cell.didAddToCartPressed = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.addProductToCart(product: strongSelf.products[indexPath.row])
            strongSelf.showAlert(title: "Congratulations", message: "\(strongSelf.products[indexPath.row].name) added to cart successfully")
        }
        return cell
    }
}

//MARK: - UISearchBarDelegate
extension ProductListViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = (!searchText.trimmingCharacters(in: .whitespaces).isEmpty) ? searchText : ""
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchText = ""
    }
}
