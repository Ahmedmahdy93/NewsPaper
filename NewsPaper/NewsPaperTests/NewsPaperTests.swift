//
//  NewsPaperTests.swift
//  NewsPaperTests
//
//  Created by Ahmed Mahdy on 26/09/2021.
//

import XCTest
import RxSwift
import Moya
import RxTest
@testable import NewsPaper

class NewsPaperTests: XCTestCase {

    var viewModel: HomeViewModel!
    var reposiotry: NewsSearchRepository!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        reposiotry = NewsSearchRepository(provider: MoyaProvider<NewsTarget>(stubClosure: MoyaProvider.immediatelyStub))
        viewModel = HomeViewModel(reposiotry)
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
    }

    override func tearDown() {
        viewModel = nil
    }

    func testNewsSuccess() {
        let article = scheduler.createObserver([Article].self)
        viewModel
            .articles
            .bind(to: article)
            .disposed(by: disposeBag)
        scheduler.start()
        viewModel.fetch()
        XCTAssertEqual(article.events.first?.value.element?.first?.source?.name, "Blogspot.com")
    }

}
