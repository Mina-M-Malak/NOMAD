//
//  CartViewModel.swift
//  NOMAD
//
//  Created by Mina Mounir on 6/17/22.
//

import Foundation
import Combine

enum CartState{
    case idle
    case empty
    case success([Product])
}

class CartViewModel{
    
    @Published var result: CartState = .empty
    
    func fetchData(){
        if let products = CoreDataManager.shared.getCartItems().0 , !products.isEmpty{
            result = .success(products)
        }
        else{
            result = .empty
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
    
    func didChangeProductQuantity(product: Product,isPlus: Bool){
        if product.quantity == 1 , !isPlus {
            deleteProduct(product: product)
            return
        }
        CoreDataManager.shared.editCartItem(product: product, isPlus: isPlus)
        fetchData()
    }
}
