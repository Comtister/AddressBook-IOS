//
//  ProfileTableViewCell.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 23.04.2021.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet var nameLbl : UILabel!
    @IBOutlet var mailLbl : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
