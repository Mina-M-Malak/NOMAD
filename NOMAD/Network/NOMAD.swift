//
//  NOMAD.swift
//  NOMAD
//
//  Created by Mina Mounir on 6/16/22.
//

import Foundation

enum NOMAD {
    case getProductList
}

extension NOMAD: Endpoint {
    var base: String {
        return Bundle.main.baseURL
    }
    
    var urlSubFolder: String {
        return Bundle.main.urlSubFolder
    }
    
    var prefix: String {
        return Bundle.main.apiPrefix
    }
    
    var path: String {
        switch self {
        case .getProductList:
            return "4e23865c-b464-4259-83a3-061aaee400ba"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default :
            return .get
        }
    }
    
    var headers : [httpHeader] {
        let httpHeaders: [httpHeader] = []
        
        switch self {
        default:
            return httpHeaders
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        default:
            return []
        }
    }
    
    var body: [String: Any]? {
        switch self {
        default:
            return nil
        }
    }
    
    var Cancellable : Bool {
        switch self {
        default:
            return false
        }
    }
}


extension URLRequest{
    mutating func addHeaders(_ Headers:[httpHeader]){
        for Header in Headers {
            self.addValue(Header.value, forHTTPHeaderField: Header.key)
        }
    }
}

extension Bundle {
    var baseURL: String {
        return object(forInfoDictionaryKey: "BaseURL") as? String ?? ""
    }
    
    var urlSubFolder: String {
        return object(forInfoDictionaryKey: "URLSubFolder") as? String ?? ""
    }
    
    var apiPrefix: String {
        return "/"
    }
}
