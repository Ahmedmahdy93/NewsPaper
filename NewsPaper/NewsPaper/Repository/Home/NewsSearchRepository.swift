//
//  NewsSearchRepository.swift
//  NewsPaper
//
//  Created by Ahmed Mahdy on 26/09/2021.
//

import Foundation
import RxSwift
import Moya

class NewsSearchRepository: Repository {
    var cachingPolicy: CachingPolicy
    var provider: MoyaProvider<NewsTarget>
    
    public init(provider: MoyaProvider<NewsTarget> = MoyaProvider<NewsTarget>(plugins: [ NetworkLoggerPlugin() ]), cachingPolicy: CachingPolicy = .NetworkOnly) {
        self.cachingPolicy = cachingPolicy
        self.provider = provider
    }
    func search(keyword: String, page: Int) -> Observable<News> {
        return getData(.search(keyword: keyword, page: page), decodingType: News.self)
    }
}
