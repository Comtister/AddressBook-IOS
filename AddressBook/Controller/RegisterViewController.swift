//
//  RegisterViewController.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 7.04.2021.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    enum registerProblems : String {
        case emptyFields = "Fill in all the fields"
        case incorrectPasswords = "Passwords don't match"
        case invalidPasswords = "password must contain at least 6 characters"
        case auth = "Was the problem..."
    }
    
    @IBOutlet var usernameTextInput : LoginField!
    @IBOutlet var mailTextInput : LoginField!
    @IBOutlet var nameTextInput : LoginField!
    @IBOutlet var passTextInput : LoginField!
    @IBOutlet var passTwoTextInput : LoginField!
    
    @IBOutlet var registerBtn : LoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func registerAction(_ sender : Any){
        //Control Statements
        guard mailTextInput.text != "" else {
            showTextInputError(.emptyFields)
            return
        }
        guard usernameTextInput.text != "" else {
            showTextInputError(.emptyFields)
            return
        }
        guard nameTextInput.text != "" else {
            showTextInputError(.emptyFields)
            return
        }
        guard passTextInput.text != "" else {
            showTextInputError(.emptyFields)
            return
        }
        guard passTwoTextInput.text != "" else {
            showTextInputError(.emptyFields)
            return
        }
        
        guard passTextInput.text == passTwoTextInput.text else {
            showTextInputError(.incorrectPasswords)
            return
        }
        
        guard passTextInput.text!.count >= 6 else {
            showTextInputError(.invalidPasswords)
            return
        }
        
        
        
    }
    
    private func showTextInputError(_ problem : registerProblems){
        
        let ac = UIAlertController(title: "Ops", message: problem.rawValue, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Close", style: .destructive, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
    

}
