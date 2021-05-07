//
//  AddressListViewController.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 28.04.2021.
//

import UIKit

class AddressListViewController: UIViewController {

    @IBOutlet var addressList : UITableView!
    private var datas : [Address]  = [Address]()
    
    private var isFirstLoad: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addressList.delegate = self
        addressList.dataSource = self
        
    }
    
    @IBAction func unwind(_ segue : UIStoryboardSegue){
        
    }

    override func viewDidAppear(_ animated: Bool) {
       
        if isFirstLoad{
            getDatas()
        }
        
    }
    
    private func getDatas(){
        print("burada Çalışıyor")
        let databaseManager = DatabaseManager.shared
        databaseManager.getAddresses { [weak self] (addresses, error) in
            print("Hayırt burda")
            self?.datas.append(addresses!)
            self?.addressList.reloadData()
        }
        isFirstLoad = false
    }

}


extension AddressListViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AdressListCell", for: indexPath) as? AddressListTableViewCell{
            cell.addressImage.image = datas[indexPath.row].photo!
            cell.addressTitle.text = datas[indexPath.row].title
            cell.addressDesc.text = datas[indexPath.row].desc
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
