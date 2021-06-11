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
    
   
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLbl.text = user?.username
        fullnameLbl.text = user?.fullname
        mailLbl.text = user?.email
        
        requestBtn.isHidden = true
        
        UserManager.shared.compareRequest(username: user!.username) { [weak self] (state, error) in
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
        
        UserManager.shared.sendRequest(user: user!) {[weak self] (error) in
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
