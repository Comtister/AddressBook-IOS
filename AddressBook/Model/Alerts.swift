//
//  Alerts.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 6.05.2021.
//

import Foundation
import UIKit

class Alerts{
    
    
    public static func showBasicDialog(VC : UIViewController , titles : String... , messages : String){
        let alert = UIAlertController(title: titles[0], message: messages, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: titles[1], style: .default, handler: nil))
        VC.present(alert, animated: true, completion: nil)
    }
    
    public static func showErrorDialog(VC : UIViewController? , titles : String... , error : Error){
        let ac = UIAlertController(title: titles[0], message: error.localizedDescription, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: titles[1], style: .destructive, handler: nil))
        VC?.present(ac, animated: true, completion: nil)
    }
    
}
