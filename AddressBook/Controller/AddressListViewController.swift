//
//  AddressListViewController.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 28.04.2021.
//

import UIKit

class AddressListViewController: UIViewController {

    @IBOutlet var addressList : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addressList.delegate = self
        addressList.dataSource = self
       
    }
    

    

}

extension AddressListViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AdressListCell", for: indexPath) as? AddressListTableViewCell{
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
