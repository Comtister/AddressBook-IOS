//
//  LoginField.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 31.03.2021.
//

import UIKit

@IBDesignable
class LoginField: UITextField {

   @IBInspectable var imageName : String!{
        didSet{
            setLeftImage(imageName: imageName)
        }
    }
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue])
        
    }
   
    private func setLeftImage(imageName : String){
        self.leftViewMode = .always
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let iconView = UIImageView(frame: CGRect(x: 5, y: 0, width: 20, height: 20))
        iconView.image = UIImage(named: imageName)
        iconView.contentMode = .scaleAspectFit
        iconContainer.addSubview(iconView)
        self.leftView = iconContainer
    }

}
