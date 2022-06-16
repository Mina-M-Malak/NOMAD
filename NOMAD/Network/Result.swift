//
//  Result.swift
//  NOMAD
//
//  Created by Mina Mounir on 6/16/22.
//

import Foundation

struct EmptyResponse:Decodable{}

struct APIResponse<R: Decodable>: Decodable {
    let nextPage:Bool
    var data:R
    
    enum CodingKeys:String, CodingKey {
        case data
        case nextPage = "has_page"
    }
}

struct GeneralErrorMessage: Decodable {
    var message: String?
}

struct httpHeader: Decodable {
    var key:String
    var value:String
}
