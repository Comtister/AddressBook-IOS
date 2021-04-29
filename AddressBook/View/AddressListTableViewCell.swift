//
//  AddressListTableViewCell.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 28.04.2021.
//

import UIKit

class AddressListTableViewCell: UITableViewCell {

    @IBOutlet var addressImage : UIImageView!
    @IBOutlet var addressTitle : UILabel!
    @IBOutlet var addressDesc : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
