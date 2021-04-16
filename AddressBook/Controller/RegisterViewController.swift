//
//  RegisterViewController.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 7.04.2021.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet var usernameTextInput : LoginField!
    @IBOutlet var mailTextInput : LoginField!
    @IBOutlet var nameTextInput : LoginField!
    @IBOutlet var passTextInput : LoginField!
    @IBOutlet var passTwoTextInput : LoginField!
    
    @IBOutlet var registerBtn : LoginButton!
    
    let progressIndicator : UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setIndicator()
 
    }
    
    private func setIndicator(){
        self.view.addSubview(progressIndicator)
        progressIndicator.color = UIColor(named: "PrimaryColor")
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        progressIndicator.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        progressIndicator.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    @IBAction func registerAction(_ sender : Any){
        //Control Statements
        guard NetworkMonitor.shared.isConnected else{
            showTextInputError(RegisterErrors.connectionProblem)
            return
        }
        guard mailTextInput.text != "" else {
            showTextInputError(RegisterErrors.emptyFields)
            return
        }
        guard usernameTextInput.text != "" else {
            showTextInputError(RegisterErrors.emptyFields)
            return
        }
        guard nameTextInput.text != "" else {
            showTextInputError(RegisterErrors.emptyFields)
            return
        }
        guard passTextInput.text != "" else {
            showTextInputError(RegisterErrors.emptyFields)
            return
        }
        guard passTwoTextInput.text != "" else {
            showTextInputError(RegisterErrors.emptyFields)
            return
        }
        guard passTextInput.text == passTwoTextInput.text else {
            showTextInputError(RegisterErrors.incorrectPasswords)
            return
        }
        guard passTextInput.text!.count >= 6 else {
            showTextInputError(RegisterErrors.invalidPasswords)
            return
        }
        progressIndicator.startAnimating()
        
        AuthManager.registerAccount(mail: mailTextInput.text!, password: passTextInput.text!, username: usernameTextInput.text!, fullName: nameTextInput.text!) { [weak self] (error) in
            if let error = error{
                self?.showTextInputError(error)
                self?.progressIndicator.stopAnimating()
                return
            }
            self?.progressIndicator.stopAnimating()
            self?.performSegue(withIdentifier: "RegisterMainSegue", sender: nil)
        }
        
    }
 
    private func showTextInputError(_ problem : Error){
        
        let ac = UIAlertController(title: "Ops", message: problem.localizedDescription, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Close", style: .destructive, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
    
   
    
}

