//
//  ViewController.swift
//  NewsPaper
//
//  Created by Ahmed Mahdy on 26/09/2021.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa
import SwiftUI

class HomeViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    private var searchBarController: UISearchController!
    private var searchTableView: UITableView!
    private var isFirstTimeActive = true

    let disposeBag = DisposeBag()
    var viewModel = HomeViewModel()
    public var articles = BehaviorRelay<[Article]>(value: [])
    public var searchTerms = BehaviorRelay<[String]>(value: [])

    // MARK: - View's Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
        createSearchBar()
    }
    override func viewDidAppear(_ animated: Bool) {
        if isFirstTimeActive {
            searchBarController.isActive = true
            isFirstTimeActive = false
        }
    }
    // MARK: - Bindings for collectionsImages
    func setUpBindings() {
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: NewsTableViewCell.self))

        // binding articles to self.articles
        viewModel
            .articles
            .observe(on: MainScheduler.instance)
            .bind(to: articles)
            .disposed(by: disposeBag)

        // binding loading to vc
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .bind(to: self.rx.isAnimating)
            .disposed(by: disposeBag)
        viewModel
            .isError
            .observe(on: MainScheduler.instance)
            .bind(to: self.rx.isError)
            .disposed(by: disposeBag)

        // binding articles to tableview
        articles.bind(to: tableView.rx.items(cellIdentifier: "NewsTableViewCell", cellType: NewsTableViewCell.self)) { (row,article,cell) in
            cell.article = article
            }.disposed(by: disposeBag)
        // subscribe on will display cell
        tableView.rx.willDisplayCell.subscribe(onNext: {[weak self] (cell,indexPath) in
            guard let self = self else { return }
            if indexPath.row == (self.articles.value.count - 1) {
                self.viewModel.loadNextPage()
            }
        }).disposed(by: disposeBag)
        // set layout delegate for tableview
        tableView
            .rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    // MARK: - searchBar cretation
    private func createSearchBar() {
        searchBarController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchBarController
        searchBarController.delegate = self
        searchBarController.searchBar.delegate = self
        searchBarController.obscuresBackgroundDuringPresentation = false

    }
    // MARK: - LastSearchTermsTableView cretation
    private func createLastSearchTermsTableView() {
        let barHeight: CGFloat = (navigationController?.navigationBar.frame.size.height)!
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        searchTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        searchTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: SearchTableViewCell.self))
        searchTableView.separatorColor = .clear
        self.view.addSubview(searchTableView)
        setUpTableViewBindings()
    }
    // MARK: - Bindings for LastSearchTermsTableView
    func setUpTableViewBindings() {
        viewModel
            .lastSearchTerms
            .observe(on: MainScheduler.instance)
            .bind(to: searchTerms)
            .disposed(by: disposeBag)
        searchTerms
            .bind(to: searchTableView
                .rx
                .items(cellIdentifier: String(describing: SearchTableViewCell.self),
                                               cellType: SearchTableViewCell.self))
            { (row,search,cell) in
                cell.nameLabel.text = search
            }.disposed(by: disposeBag)

        searchTableView.rx.itemSelected.subscribe(onNext: {[weak self] (indexPath) in
            guard let self = self else { return }
            let cell = self.searchTableView.cellForRow(at: indexPath) as? SearchTableViewCell
            self.searchBarController.searchBar.text = cell?.nameLabel.text
            self.searchBarSearchButtonClicked(self.searchBarController.searchBar)
        }).disposed(by: disposeBag)
    }

    func removeTableView() {
        if searchTableView != nil {
            searchTableView.removeFromSuperview()
            searchTableView = nil
        }
    }

}

// MARK: - searchBar delegates
extension HomeViewController: UISearchControllerDelegate, UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text.count > 1 else {
            return
        }
        self.title = text
        searchBarController.isActive = false
        viewModel.saveSearchTerm(name: text)
        searchBarController.searchBar.resignFirstResponder()
        viewModel.search(with: text)
        removeTableView()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        createLastSearchTermsTableView()
        viewModel.getLastSearchTerms()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        removeTableView()
    }
}

// MARK: - collectionView layout delegates
extension HomeViewController:  UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles.value[indexPath.row]
        if let viewController = DetailsViewController.instantiateFromNib() {
            viewController.article = article
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}

