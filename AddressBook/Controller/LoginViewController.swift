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
    
    let progressIndicator : UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setIndicator()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       checkConnection()
    }
    
    
    private func setIndicator(){
        self.view.addSubview(progressIndicator)
        progressIndicator.color = UIColor(named: "PrimaryColor")
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        progressIndicator.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        progressIndicator.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    private func checkConnection(){
        if NetworkMonitor.shared.isConnected{
            return
        }else{
            let ac = UIAlertController(title: "Error", message: "Network Error", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Close", style: .destructive, handler: nil))
            self.present(ac, animated: true, completion: nil)
        }
    }
    
    @IBAction func goToRegisterVC(_ sender : Any){
        performSegue(withIdentifier: "RegisterSegue", sender: nil)
    }
    
    @IBAction func loginAction(_ sender : UIButton){
        //Control Statements
        guard mailTextInput.text != "" else {
            Alerts.showErrorDialog(VC: self, titles: "Ops","Close", error: RegisterErrors.emptyFields)
            return
        }
        guard passTextInput.text != "" else {
            Alerts.showErrorDialog(VC: self, titles: "Ops","Close", error: RegisterErrors.emptyFields)
            return
        }
        progressIndicator.startAnimating()
        AuthManager.loginAccount(email: mailTextInput.text!, password: passTextInput.text!) { [weak self] (resultData, error) in
            self?.progressIndicator.stopAnimating()
            if let error = error{
                Alerts.showErrorDialog(VC: self, titles: "Ops","Close", error: error)
                return
            }
            self?.performSegue(withIdentifier: "MainSegue", sender: nil)
        }
        
    }
    


}
