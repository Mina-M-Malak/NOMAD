//
//  CartViewModel.swift
//  NOMAD
//
//  Created by Mina Mounir on 6/17/22.
//

import Foundation

enum CartState{
    case empty
    case success([Product])
}

class CartViewModel{
    
    var result: ((_ state: CartState) ->())?
    
    func fetchData(){
        if let products = CoreDataManager.shared.getCartItems().0 , !products.isEmpty{
            result?(.success(products))
        }
        else{
            result?(.empty)
        }
    }
    
    func getProductsPrice()-> Double{
        let totalPrice = CoreDataManager.shared.getCartItems().0?.map{Double($0.quantity ?? 1) * $0.retailPrice}.reduce(0, +)
        return totalPrice ?? 0
    }
    
    func deleteProduct(product: Product){
        CoreDataManager.shared.removeProduct(product: product)
        fetchData()
    }
}
