//
//  RegisteredUsersViewController.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 3.06.2021.
//

import UIKit

class RegisteredUsersViewController: UIViewController {

    
    @IBOutlet var tableView : UITableView!
    
    var users : [User] = [User]()
    
    let progressIndicator : UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setIndicator()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getRegistereds()
    }
    
    private func setIndicator(){
        self.view.addSubview(progressIndicator)
        progressIndicator.color = UIColor(named: "PrimaryColor")
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        progressIndicator.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        progressIndicator.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    private func getRegistereds(){
        progressIndicator.startAnimating()
        UserManager.shared.getSharedUsers { [weak self] (usersData, error) in
            self?.progressIndicator.stopAnimating()
            if let error = error{
                //show error
                return
            }
            
            guard let usersData = usersData else { return }
            self?.tableView.isHidden = false
            self?.users = usersData
            self?.tableView.reloadData()
        }
        
    }
    

}

extension RegisteredUsersViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = users[indexPath.row].username
        
        return cell
        
    }
    
    
    
    
}
