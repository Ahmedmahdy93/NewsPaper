//
//  NewsSearchRepository.swift
//  NewsPaper
//
//  Created by Ahmed Mahdy on 26/09/2021.
//

import Foundation
import RxSwift
import Moya

class FlickrSearchRepository: Repository {
    var cachingPolicy: CachingPolicy
    var provider: MoyaProvider<NewsTarget>
    
    public init(provider: MoyaProvider<NewsTarget> = MoyaProvider<NewsTarget>(plugins: [ VerbosePlugin(verbose: true) ]), cachingPolicy: CachingPolicy = .NetworkOnly) {
        self.cachingPolicy = cachingPolicy
        self.provider = provider
    }
    func search(keyword: String, page: Int) -> Observable<News> {
        return getData(.search(keyword: keyword, page: page), decodingType: News.self)
    }
}
struct VerbosePlugin: PluginType {
    let verbose: Bool

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        #if DEBUG
        if let body = request.httpBody,
           let str = String(data: body, encoding: .utf8) {
            if verbose {
                print("request to send: \(str))")
            }
        }
        #endif
        return request
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        #if DEBUG
        switch result {
        case .success(let body):
            if verbose {
                print("Response:")
                if let json = try? JSONSerialization.jsonObject(with: body.data, options: .mutableContainers) {
                    print(json)
                } else {
                    let response = String(data: body.data, encoding: .utf8)!
                    print(response)
                }
            }
        case .failure( _):
            break
        }
        #endif
    }

}
