//
//  NewsTarget.swift
//  NewsPaper
//
//  Created by Ahmed Mahdy on 26/09/2021.
//

import Foundation
import Moya

enum NewsTarget {
    static private var apiKey = "389de3258ce44f499397d14e11c96553"
    static let perPage = 20
    case search(keyword: String, page: Int)
}

extension NewsTarget: TargetType {
    
    
    var baseURL: URL {
        return URL(string: "https://newsapi.org/v2/everything")!
    }
    
    var path: String {
        switch self {
        case .search:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .search:
            return .get
        }
    }
    
    public var sampleData: Data {
        if let path = Bundle.main.path(forResource: "ImageResultMock", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
              } catch {
                   // handle error
                return Data()
              }
        }
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .search(let keyword, let page):
            var urlParams = [String:Any]()
            urlParams = [
                "q": keyword,
                "api_key": NewsTarget.apiKey,
                "pageSize": NewsTarget.perPage,
                "page": page
            ]
            return .requestParameters(parameters: urlParams, encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
}
