//
//  HomeViewModel.swift
//  NewsPaper
//
//  Created by Ahmed Mahdy on 26/09/2021.
//

import Foundation
import RxSwift
import Moya

class HomeViewModel: BaseViewModel {
    
    var isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    public let articles : PublishSubject<[Article]> = PublishSubject()
    public let lastSearchTerms: PublishSubject<[String]> = PublishSubject()
    var isError: PublishSubject<Error> = PublishSubject()
    var disposeBag: DisposeBag = DisposeBag()
    private var repository: FlickrSearchRepository
    
    private let dataManager = coreDataManager()
    private var keyword = ""
    private var pageNumber = 1
    private var totalPages = 1
    private(set) var articleArray = [Article]()
    
    init (_ repo: FlickrSearchRepository = FlickrSearchRepository()) {
        repository = repo
    }
    func search(with text: String) {
        keyword = text
        articleArray.removeAll()
        fetch()
    }
    func fetch() {
        self.isLoading.onNext(true)
        let observable = repository.search(keyword: keyword, page: pageNumber)
        getData(observable, decodingType: News.self).observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                if result.status.uppercased().contains("OK") {
                    self.articleArray += result.articles ?? []
                    self.totalPages = (result.totalResults ?? 20 / NewsTarget.perPage)
                    self.articles.onNext(self.articleArray)
                }
            } onError: {_ in
            }.disposed(by: disposeBag)
    }
    func loadNextPage() {
        if pageNumber < totalPages {
            pageNumber += 1
            fetch()
        }
    }

    func getLastSearchTerms() {
        lastSearchTerms.onNext(dataManager.getLastSearchTerms())
    }

    func saveSearchTerm(name: String){
        dataManager.save(name: name)
    }
}

