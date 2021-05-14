//
//  UserSearchViewController.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 14.05.2021.
//

import UIKit

class UserSearchViewController: UIViewController {
   
    @IBOutlet var searchList : UITableView!
    @IBOutlet var searchBar : UISearchBar!
    
    private var datas : [User] = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        setList()
        
        
    }
    
    private func setList(){
        
        searchList.dataSource = self
        searchList.delegate = self
        searchList.isHidden = true
        
    }
    

}

extension UserSearchViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userList", for: indexPath)
            cell.textLabel?.text = datas[indexPath.row].username
            cell.detailTextLabel?.text = datas[indexPath.row].fullname
            
            return cell
        
        
       
    }
    
    
}

extension UserSearchViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else { searchList.isHidden = true ; return }
        
        searchList.isHidden = false
        let lowText = searchText.lowercased()
        
        DatabaseManager.shared.getUsers(searchText: lowText) { [weak self] (datas, error) in
            if let error = error{
                //show error
                Alerts.showErrorDialog(VC: self, titles: "Error", error: error)
                return
            }
            
            guard let datas = datas else { return }
            
            self?.datas = datas
            self?.searchList.reloadData()
            
        }
        
    }
    
}
