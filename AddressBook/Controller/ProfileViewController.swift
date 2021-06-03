//
//  ProfileViewController.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 22.05.2021.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var profileImg : UIImageView!
    @IBOutlet var usernameLbl : UILabel!
    @IBOutlet var fullnameLbl : UILabel!
    @IBOutlet var mailLbl : UILabel!
    @IBOutlet var requestBtn : UIButton!
    
    var profilImage : UIImage?
    var username : String?
    var fullname : String?
    var mail : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLbl.text = username
        fullnameLbl.text = fullname
        mailLbl.text = mail
        
        requestBtn.isHidden = true
        
        DatabaseManager.shared.compareRequest(username: username!) { [weak self] (state, error) in
            if let error = error{
                //Show error
                return
            }
            guard let state = state else {return}
            
            switch state{
            case .noRelation:
                self?.requestBtn.isHidden = false
                break
            case .relation:
                self?.requestBtn.isEnabled = false
                self?.requestBtn.setTitle("Use Registered", for: .disabled)
                self?.requestBtn.isHidden = false
            case .requestReletion:
                self?.requestBtn.isEnabled = false
                self?.requestBtn.setTitle("Request Sent", for: .disabled)
                self?.requestBtn.isHidden = false
            }
            
           
        }
        
    }
    
    

    @IBAction func invite(_ sender : UIButton){
        
        DatabaseManager.shared.sendRequest(username: username!) {[weak self] (error) in
            if let error = error{
                //show error
                return
            }
            self?.requestBtn.isHidden = true
            self?.requestBtn.setTitle("Request Sent", for: .disabled)
            self?.dismiss(animated: true, completion: nil)
        }
        
    }

}
