//
//  SearchViewController.swift
//  CloneTwitter
//
//  Created by Phạm Hồng Sơn on 16/02/2024.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    private let user = [[String:String]]()
    private let hasFetched = false
    private let searchController:UISearchController = {
       let search = UISearchController(searchResultsController: SearchResultsViewController())
        search.searchBar.searchBarStyle = .minimal
        search.searchBar.placeholder = "Search with @username"
        return search
    }()
    private let promtLable:UILabel = {
        let lable = UILabel()
        lable.text = "Search for users and get connected"
        lable.textAlignment = .center
        lable.numberOfLines = 0
        lable.font = .systemFont(ofSize: 32,weight: .bold)
        lable.textColor = .placeholderText
        return lable
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(promtLable)
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        configureConstrain()
    }
    private func configureConstrain(){
        promtLable.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(view.snp.centerY)
        }
    }
    
    
}
extension SearchViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController else{return}
        
        DatabaseManager.shared.collectionUsers(search: searchController.searchBar.text ?? "") {[weak self] results in
            switch results {
            case .success(let users):
                resultsController.update(users: users)
            case .failure(let err):
                print("Lỗi: \(err)")
            }
        }
    }
}
