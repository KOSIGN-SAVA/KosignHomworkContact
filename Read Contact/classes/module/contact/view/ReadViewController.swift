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
    var contactsNameInCollectionView:[DataContact]=[]
    var numberArray = NSMutableArray()
    var selectedArray=NSMutableArray()
    var processCircle=UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //table view configuration
        tableViewFooter.delegate=self
        tableViewFooter.dataSource=self
        
        //indicator configuration
        processCircle.center=view.center
        processCircle.hidesWhenStopped=true
        processCircle.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.gray
        
        //collection view configuration
        collectionViewHeader.delegate=self
        collectionViewHeader.dataSource=self
        
        self.presenter=ContactPresenter()
        self.presenter?.reader=self
        self.startReadContact()
    }
    
    func showMessage(message: String) {
        let alertController = UIAlertController(title: "Hey man!", message: message, preferredStyle: .alert)
        let settingAction = UIAlertAction(title: "Go to setting!", style: UIAlertActionStyle.default) { (action) -> Void in
            UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
            UIApplication.shared.canOpenURL(URL(string:UIApplicationOpenSettingsURLString)!)
        }
        alertController.addAction(settingAction)
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        _=navigationController?.popViewController(animated: true)
    }
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        //save to main list
        for index in 0..<contactsNameInCollectionView.count{
            for index2 in 0..<mySelectedContact.count{
                
            }
        }
        mySelectedContact.append(contentsOf: contactsNameInCollectionView)
        _=self.navigationController?.popViewController(animated: true)
    }
}

extension ReadViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableViewFooter.dequeueReusableCell(withIdentifier: "idtReqCell", for: indexPath) as? DeviceContactCell
        cell?.givenName.text=contacts[indexPath.row].contactName
        cell?.phoneNumber.text=contacts[indexPath.row].contactNumber
        //cell?.tickButton.addTarget(self, action: #selector(tickAction(_:)), for: .touchUpInside)
        cell?.tickButton.tag=indexPath.row
        if selectedArray.contains(numberArray.object(at: indexPath.row)) {
            cell?.tickButton.setBackgroundImage(#imageLiteral(resourceName: "Select"), for: UIControlState())
        }else{
            cell?.tickButton.setBackgroundImage(#imageLiteral(resourceName: "Diselect"), for: UIControlState())
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tickAction2(tag: indexPath.row)
    }
    
    func tickAction(_ sender: UIButton){
        let value = sender.tag
        if selectedArray.contains(numberArray.object(at: value)) {
            selectedArray.remove(numberArray.object(at: value))
            //contactsNameInCollectionView.remove(at: contactsNameInCollectionView.index(of: contacts[value].contactName)!)
        }else{
            selectedArray.add(numberArray.object(at: value))
            //contactsNameInCollectionView.append(contacts[value].contactName)
        }
        DispatchQueue.main.async {
            self.collectionViewHeader.reloadData()
            self.tableViewFooter.reloadData()
        }
    }
    
    func tickAction2(tag:Int){
        let value = tag
        let data=DataContact(contactName: contacts[value].contactName, contactNumber: contacts[value].contactNumber)
        if selectedArray.contains(numberArray.object(at: value)) {
            selectedArray.remove(numberArray.object(at: value))
            //contactsNameInCollectionView.remove(at: contactsNameInCollectionView.index(of: contacts[value].contactName)!)
            contactsNameInCollectionView.remove(at: contactsNameInCollectionView.index(where: {$0.contactName==contacts[value].contactName && $0.contactNumber==contacts[value].contactNumber})!)
        }else{
            selectedArray.add(numberArray.object(at: value))
            //contactsNameInCollectionView.append(contacts[value].contactName)
            contactsNameInCollectionView.append(data)
        }
        DispatchQueue.main.async {
            self.collectionViewHeader.reloadData()
            self.tableViewFooter.reloadData()
        }
    }
    
}

extension ReadViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contactsNameInCollectionView.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionViewHeader.dequeueReusableCell(withReuseIdentifier: "idtCollectionView", for: indexPath) as? MyCollectionViewCell
        cell?.labelCollection.text=contactsNameInCollectionView[indexPath.row].contactName
        return cell!
    }
}

extension ReadViewController:ContactPresenterInterface{
    
    func responseMessage(msg: String) {
        self.showMessage(message: msg)
    }
    
    func startReadContact() {
        view.addSubview(processCircle)
        processCircle.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.presenter?.requestAccess()
        })
    }
    
    func responseContact(contact: [DataContact]) {
        self.contacts=contact
        for index in 0..<contact.count{
            numberArray.add(index)
        }
        DispatchQueue.main.async {
            self.tableViewFooter.reloadData()
        }
        processCircle.stopAnimating()
    }
    
    func errorContact() {
        showMessage(message: "No contact in your device, man!")
    }
}
