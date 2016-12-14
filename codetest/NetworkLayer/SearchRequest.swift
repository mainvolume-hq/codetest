//
//  File.swift
//  codetest
//
//  Created by mainvolume on 12/14/16.
//  Copyright © 2016 mainvolume. All rights reserved.
//

import Foundation

final class SearchRequest: BackendAPIRequest {
    
    
    private let searchItems: String
    
    init(searchItems:String) {
        self.searchItems = searchItems
        print(endpoint)
    }
    
    var endpoint: String {
        return "/search"
    }
    
    var method: NetworkService.Method {
        return .get
    }
    
    var query: NetworkService.QueryType {
        return .path
    }
    
    var parameters: [String : Any]? {
        return [
            "term":searchItems
        ]
    }
    
    var headers: [String : String]? {
        return defaultJSONHeaders()
    }
}

