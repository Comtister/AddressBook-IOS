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
        
      
        
        setRequest()
        
        progressIndicator.hidesWhenStopped = true
        
        addressList.delegate = self
        addressList.dataSource = self
        
        
    }
    
    private func setRequest(){
        DatabaseManager.shared.fetchRequest(username: AuthManager.getProfile()!.username) { [weak self] (error) in
            if let error = error{
                //Show error
                return
            }
            
            self?.tabBarController?.tabBar.items![3].badgeValue = (Link.sharedLinks.links.count > 0) ? String(Link.sharedLinks.links.count) : nil
            
        }
    }
    
    @IBAction func unwind(_ segue : UIStoryboardSegue){
        
    }

    override func viewDidAppear(_ animated: Bool) {
        print("çalıştı")
        if firstStart{
            addressList.isHidden = true
            progressIndicator.startAnimating()
            dbManager.getAddresses { [weak self] (addresses, error) in
                if let error = error{
                    //Show Error Message
                    print(error.localizedDescription)
                    Alerts.showErrorDialog(VC: self, titles: "Error","Ok", error: error)
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
       
        if let senderData = sender as? Address{
           
            if let VC = segue.destination as? AdressShareViewController{
                VC.address = senderData
            }
            return
        }
        
        if let sendarData = sender as? [Any]{
            
            let key = sendarData[0] as? String
            
            switch key {
            case "Add":
                if let VC = segue.destination as? MapViewController{
                    VC.segueKey = "Add"
                }
                break
            case "Show":
                if let VC = segue.destination as? MapViewController{
                    VC.segueKey = "Show"
                    VC.address = sendarData[1] as? Address
                }
                break
            default:
                break
            }
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
   
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contextDelete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, boolValue) in
            boolValue(true)
           
            DatabaseManager.shared.deleteAddress(id: (self?.datas[indexPath.row].id)!) { (error) in
                if let error = error{
                    //show error
                    return
                }
                self?.datas.remove(at: indexPath.row)
                self?.addressList.deleteRows(at: [indexPath], with: .left)
            }
        
        }
        
        let contextShare = UIContextualAction(style: .normal, title: "Share") { [weak self] (action, view, boolValue) in
            boolValue(true)
            
            self?.performSegue(withIdentifier: "ShareAddress", sender: self?.datas[indexPath.row])
            
        }
        
        contextShare.backgroundColor = UIColor(named: "PrimaryColor")
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextDelete,contextShare])
        return swipeActions
    }
    
   
    }
    

