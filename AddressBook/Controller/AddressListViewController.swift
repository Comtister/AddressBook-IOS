//
//  AddressListViewController.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 28.04.2021.
//

import UIKit

class AddressListViewController: UIViewController {

    @IBOutlet var addressList : UITableView!
    @IBOutlet var progressIndicator : UIActivityIndicatorView!
    @IBOutlet var barAddButton : UIBarButtonItem!
    
    private let dbManager : DatabaseManager = DatabaseManager.shared
    private var datas : [Address]  = [Address]()
    private var firstStart : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressIndicator.hidesWhenStopped = true
        
        addressList.delegate = self
        addressList.dataSource = self
        
    }
    
    @IBAction func unwind(_ segue : UIStoryboardSegue){
        
    }

    override func viewDidAppear(_ animated: Bool) {
       
        if firstStart{
            addressList.isHidden = true
            progressIndicator.startAnimating()
            dbManager.getAddresses { [weak self] (addresses, error) in
                if let error = error{
                    //Show Error Message
                    Alerts.showErrorDialog(VC: self, titles: "Error", error: error)
                    self?.addressList.isHidden = false
                    self?.progressIndicator.stopAnimating()
                    self?.firstStart = false
                    return
                }
                
                if let addresses = addresses{
                    self?.datas.append(addresses)
                    self?.addressList.isHidden = false
                    self?.addressList.reloadData()
                    self?.progressIndicator.stopAnimating()
                    self?.firstStart = false
                    return
                }
                
                
                self?.progressIndicator.stopAnimating()
                self?.firstStart = false
                
            }
            
        }
        
        
    }
    
    
    
    @IBAction func gotoMapViewAddAction(_ sender : UIBarButtonItem){
        
        performSegue(withIdentifier: "AddAddress", sender: ["Add"])
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let sendarData = sender as? [Any]
        let key = sendarData![0] as? String
        
        switch key {
        case "Add":
            if let VC = segue.destination as? MapViewController{
                VC.segueKey = "Add"
            }
            break
        case "Show":
            if let VC = segue.destination as? MapViewController{
                VC.segueKey = "Show"
                VC.address = sendarData![1] as? Address
            }
            break
        default:
            break
        }
        
       
        
    }

}


extension AddressListViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let address = datas[indexPath.row]
        performSegue(withIdentifier: "AddAddress", sender: ["Show",address])
    }
   
    
    
}
