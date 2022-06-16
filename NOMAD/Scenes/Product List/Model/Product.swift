//
//  Product.swift
//  NOMAD
//
//  Created by Mina Mounir on 6/17/22.
//

import Foundation

struct Product: Codable {
    var id: String = ""
    var name: String = ""
    var description: String = ""
    var image: String = ""
    var barcode: String = ""
    var costPrice: Double? = 0
    var retailPrice: Double = 0
    var quantity: Int? = 0
    
    enum CodingKeys: String,CodingKey{
        case id , name , description , barcode , quantity
        case image = "image_url"
        case retailPrice = "retail_price"
        case costPrice = "cost_price"
    }
}
