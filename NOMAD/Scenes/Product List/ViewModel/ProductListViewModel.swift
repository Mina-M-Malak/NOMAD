//
//  ProductListViewModel.swift
//  NOMAD
//
//  Created by Mina Mounir on 6/17/22.
//

import Foundation

enum ProductListState{
    case idle
    case loading
    case success([Product])
    case failure(String)
}

class ProductListViewModel{
    
    private var products: [Product] = []
    var result: ((_ state: ProductListState) ->())?
    
    func fetchData(){
        result?(.loading)
        APIRoute.shared.fetch(with: .getProductList, model: [String: Product].self) { [weak self] (response) in
            switch response{
            case .success(let result):
                self?.result?(.success(Array(result.values)))
                self?.products = Array(result.values)
            case .failure(let error):
                self?.result?(.failure(error.localizedDescription))
            }
        }
    }
    
    func filterData(searchText: String) {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            result?(.success(products))
            return
        }
        let customProducts = products.filter({$0.name.lowercased().contains(searchText.lowercased()) || $0.description.lowercased().contains(searchText.lowercased())})
        result?(.success(customProducts))
    }
    
    func addProductToCart(product: Product){
        CoreDataManager.shared.addProductToCart(product: product)
    }
}
