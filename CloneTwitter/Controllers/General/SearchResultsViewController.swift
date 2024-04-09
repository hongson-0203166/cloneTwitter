//
//  SearchResultsViewController.swift
//  CloneTwitter
//
//  Created by Phạm Hồng Sơn on 20/03/2024.
//

import UIKit
import SnapKit
class SearchResultsViewController: UIViewController {
    
    var users : [TwitterUser] = []
    let searchResultsTableView:UITableView = {
       let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(UsersTableViewCell.self, forCellReuseIdentifier: UsersTableViewCell.identifier)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchResultsTableView)
        searchResultsTableView.dataSource = self
        configureConstrain()
    }
    private func configureConstrain(){
        searchResultsTableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    func update(users:[TwitterUser]){
        self.users = users
        DispatchQueue.main.async {[weak self] in
            self?.searchResultsTableView.reloadData()
        }
    }
}
extension SearchResultsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewCell.identifier, for: indexPath) as? UsersTableViewCell else{
            return UITableViewCell()
        }
        
        cell.configureBindata(user: users[indexPath.row])
        return cell
    }
}
