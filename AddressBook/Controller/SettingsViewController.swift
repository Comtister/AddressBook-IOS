//
//  SettingsViewController.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 23.04.2021.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet var profileCell : ProfileTableViewCell!
    @IBOutlet var istekLbl : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let profile : User? = AuthManager.shared.getProfile()
        
        profileCell.nameLbl.text = profile?.username
        profileCell.mailLbl.text = profile?.email
       
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("test test")
        if Link.sharedLinks.links.count > 0{
            istekLbl.text?.append(" (\(Link.sharedLinks.links.count) Yeni Paylaşım İsteği)")
        }else{
            istekLbl.text = "Paylaşım istekleri"
        }
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 && indexPath.row == 2{
            AuthManager.shared.closeProfile { [weak self] (error) in
                if let error = error{
                    
                    return
                }
                self?.performSegue(withIdentifier: "GoToLoginScreen", sender: nil)
            }
            return
        }
        
        if indexPath.section == 1 && indexPath.row == 1{
            
            self.performSegue(withIdentifier: "gotoShareRequests", sender: nil)
            
        }
        
        if indexPath.section == 1 && indexPath.row == 0{
            self.performSegue(withIdentifier: "gotoRegistereds", sender: nil)
        }
        
    }
    
    private func showError(error : Error){
        let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Close", style: .destructive, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
    
    
}
