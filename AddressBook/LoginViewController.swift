//
//  LoginViewController.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 7.04.2021.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var mailTextInput : LoginField!
    @IBOutlet var passTextInput : LoginField!
    
    @IBOutlet var loginBtn : LoginButton!
    @IBOutlet var registerBtn : LoginButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    
    
    @IBAction func goToRegisterVC(_ sender : Any){
        performSegue(withIdentifier: "RegisterSegue", sender: nil)
    }
    
    @IBAction func goToMainVC(_ sender : Any){
        performSegue(withIdentifier: "MainSegue", sender: nil)
    }

}
