//
//  AdressShareViewController.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 4.06.2021.
//

import UIKit

class AdressShareViewController: UIViewController {

    @IBOutlet var userTable : UITableView!
    
    let progressIndicator : UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    var registeredUsers : [User] = [User]()
    var address : Address?
    override func viewDidLoad() {
        super.viewDidLoad()

        setIndicator()
        
        userTable.delegate = self
        userTable.dataSource = self
        userTable.isHidden = true
        
        getUsers()
        
    }
    
    private func getUsers(){
        progressIndicator.startAnimating()
        UserManager.shared.getSharedUsers { [weak self] (users, error) in
            self?.progressIndicator.stopAnimating()
            if let error = error{
                //show error
                return
            }
            
            guard let users = users else { return }
            
            self?.registeredUsers = users
            self?.userTable.reloadData()
            self?.userTable.isHidden = false
        }
        
    }
    
    private func setIndicator(){
        self.view.addSubview(progressIndicator)
        progressIndicator.color = UIColor(named: "PrimaryColor")
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        progressIndicator.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        progressIndicator.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
   

}

extension AdressShareViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registeredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = registeredUsers[indexPath.row].username
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        progressIndicator.startAnimating()
        AddressManager.shared.shareAddress(address: address!, toUser: registeredUsers[indexPath.row]) { [weak self] (error) in
            self?.progressIndicator.stopAnimating()
            if let error = error{
                //show error
                return
            }
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
}
