//
//  LoginButton.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 1.04.2021.
//

import UIKit

@IBDesignable
class LoginButton: UIButton {

   

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        
        self.backgroundColor = UIColor(named: "PrimaryColor")
        self.layer.cornerRadius = 10
        
        
        
    }
    

}
