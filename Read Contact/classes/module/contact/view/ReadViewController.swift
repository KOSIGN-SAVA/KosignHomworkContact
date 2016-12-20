//
//  ReadViewController.swift
//  Read Contact
//
//  Created by Pha Vansa on 12/20/16.
//  Copyright © 2016 Pha Vansa. All rights reserved.
//

import UIKit

class ReadViewController: UIViewController {

    @IBOutlet weak var collectionViewHeader: UICollectionView!
    @IBOutlet weak var tableViewFooter: UITableView!
    var presenter:ContactPresenter?
    var contacts:[DataContact]=[]
    var numberArray = NSMutableArray()
    var selectedArray=NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewFooter.delegate=self
        tableViewFooter.dataSource=self
        self.presenter=ContactPresenter()
        self.presenter?.reader=self
        self.presenter?.requestAccess()
    }
    
    func showMessage(message: String) {
        let alertController = UIAlertController(title: "Hey man!", message: message, preferredStyle: .alert)
        let settingAction = UIAlertAction(title: "Go to setting!", style: UIAlertActionStyle.default) { (action) -> Void in
            UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
            //UIApplication.shared.canOpenURL(URL(string:UIApplicationOpenSettingsURLString)!)
        }
        alertController.addAction(settingAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

extension ReadViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableViewFooter.dequeueReusableCell(withIdentifier: "idtReqCell", for: indexPath) as? DeviceContactCell
        cell?.givenName.text=contacts[indexPath.row].contactName
        cell?.phoneNumber.text=contacts[indexPath.row].contactNumber
        cell?.tickButton.addTarget(self, action: #selector(tickAction(_:)), for: .touchUpInside)
        cell?.tickButton.tag=indexPath.row
        if selectedArray.contains(numberArray.object(at: indexPath.row)) {
            cell?.tickButton.setBackgroundImage(#imageLiteral(resourceName: "Select"), for: UIControlState())
        }else{
            cell?.tickButton.setBackgroundImage(#imageLiteral(resourceName: "Diselect"), for: UIControlState())
        }
        return cell!
    }
    
    func tickAction(_ sender: UIButton){
        let value = sender.tag;
        if selectedArray.contains(numberArray.object(at: value)) {
            selectedArray.remove(numberArray.object(at: value))
        }else{
            selectedArray.add(numberArray.object(at: value))
        }
        print("Selecetd Array \(selectedArray)")
        tableViewFooter.reloadData()
    }
    
}

extension ReadViewController:ContactPresenterInterface{
    
    func responseMessage(msg: String) {
        self.showMessage(message: msg)
    }
    
    func startReadContact() {
        //
    }
    
    func responseContact(contact: [DataContact]) {
        print("My contact: \(contact.count)")
        self.contacts=contact
        for index in 0...contact.count{
            numberArray.add(index)
        }
        print("numberArr: \(numberArray)")
        DispatchQueue.main.async {
            self.tableViewFooter.reloadData()
        }
    }
    
    func errorContact() {
        //
    }
}
