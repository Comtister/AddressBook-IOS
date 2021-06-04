//
//  ShareRequestViewController.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 26.05.2021.
//

import UIKit

class ShareRequestViewController: UIViewController {

    @IBOutlet var requestsTableView : UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestsTableView.dataSource = self
        requestsTableView.delegate = self
        
    }
    
    
    @IBAction func positiveAction(_ sender : UIButton){
        sender.isEnabled  = false
        let touchPoint = sender.convert(CGPoint.zero, to: self.requestsTableView)
        let buttonIndex = requestsTableView.indexPathForRow(at: touchPoint)
        
        DatabaseManager.shared.addUserSharedUsers(user: Link.sharedLinks.links[buttonIndex!.row]) { [weak self] (error) in
            if let error = error{
                print(error)
            }
            sender.isEnabled = true
            self?.requestsTableView.reloadData()
        }
        
    }
    
    @IBAction func negativeAction(_ sender : UIButton){
        sender.isEnabled = false
        let touchPoint = sender.convert(CGPoint.zero, to: self.requestsTableView)
        let buttonIndex = requestsTableView.indexPathForRow(at: touchPoint)
        
        DatabaseManager.shared.deleteRequestProfile(user: Link.sharedLinks.links[buttonIndex!.row]) { [weak self] (error) in
            if let error = error{
                print(error)
            }
            sender.isEnabled = true
            self?.requestsTableView.reloadData()
        }
        
    }

}


extension ShareRequestViewController : UITableViewDataSource , UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Link.sharedLinks.links.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ShareRequestCell", for: indexPath) as? ShareRequestTableViewCell{
            
            cell.usernameLbl.text = Link.sharedLinks.links[indexPath.row].username
            cell.positiveBtn.layer.cornerRadius = 5
            cell.negativeBtn.layer.cornerRadius = 5
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, boolValue) in
            boolValue(true)
            
            
            
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [action])
        return swipeActions
        
    }
    
    
}
