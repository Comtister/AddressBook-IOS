//
//  SettingsViewController.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 23.04.2021.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet var profileCell : ProfileTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let profile = AuthManager.getProfile()
        
        profileCell.nameLbl.text = profile?.username
        profileCell.mailLbl.text = profile?.email
       
    
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 && indexPath.row == 1{
            AuthManager.closeProfile { [weak self] (error) in
                if let error = error{
                    
                    return
                }
                self?.performSegue(withIdentifier: "GoToLoginScreen", sender: nil)
            }
           
        }
        
    }
    
    private func showError(error : Error){
        let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Close", style: .destructive, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
    
    
}
