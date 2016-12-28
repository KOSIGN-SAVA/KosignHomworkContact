//
//  ReadViewController.swift
//  Read Contact
//
//  Created by Pha Vansa on 12/20/16.
//  Copyright © 2016 Pha Vansa. All rights reserved.
//

import UIKit

class ReadViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var collectionViewHeader: UICollectionView!
    @IBOutlet weak var tableViewFooter: UITableView!
    @IBOutlet weak var search: UISearchBar!
    
    var item=[DataContact]()
    var filterItem=[DataContact]()
    var searchIsActive:Bool=false
    
    var presenter:ContactPresenter?
    var contacts:[DataContact]=[]
    var contactsNameInCollectionView:[DataContact]=[]
    var numberArray = NSMutableArray()
    var selectedArray=NSMutableArray()
    var processCircle=UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //cell config
        search.delegate=self
        
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
        
        //search configuration
//        search=UISearchController(searchResultsController: nil)
//        search.dimsBackgroundDuringPresentation=true
//        search.searchBar.sizeToFit()
//        search.searchResultsUpdater=self
//        tableViewFooter.tableHeaderView=search.searchBar
        
        self.presenter=ContactPresenter()
        self.presenter?.reader=self
        self.startReadContact()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterItem.removeAll(keepingCapacity: false)
        filterItem=contacts.filter({ item in
            item.contactName.lowercased().contains(searchBar.text!.lowercased())
        })
        tableViewFooter.reloadData()
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
        mySelectedContact=contactsNameInCollectionView
        _=self.navigationController?.popViewController(animated: true)
    }
}

extension ReadViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterItem.count>0{
            return filterItem.count
        }
        return contacts.count
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableViewFooter.dequeueReusableCell(withIdentifier: "idtReqCell", for: indexPath) as? DeviceContactCell
        if filterItem.count>0{
            cell?.givenName.text=filterItem[indexPath.row].contactName
            cell?.phoneNumber.text=filterItem[indexPath.row].contactNumber
            
            if filterItem[indexPath.row].isCheck {
                cell?.tickButton.setBackgroundImage(#imageLiteral(resourceName: "Select"), for: UIControlState())
            }else{
                cell?.tickButton.setBackgroundImage(#imageLiteral(resourceName: "Diselect"), for: UIControlState())
            }
        }else{
            cell?.givenName.text=contacts[indexPath.row].contactName
            cell?.phoneNumber.text=contacts[indexPath.row].contactNumber
            
            if contacts[indexPath.row].isCheck {
                cell?.tickButton.setBackgroundImage(#imageLiteral(resourceName: "Select"), for: UIControlState())
            }else{
                cell?.tickButton.setBackgroundImage(#imageLiteral(resourceName: "Diselect"), for: UIControlState())
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var tag=indexPath.row
        if filterItem.count>0 {
            tag = contacts.index(where: {$0.contactName==filterItem[indexPath.row].contactName && $0.contactNumber==filterItem[indexPath.row].contactNumber})!
        }
        tickAction2(tag: tag, indexSearch: indexPath.row)
    }
    
    func tickAction2(tag:Int, indexSearch:Int){
        let data = DataContact(contactName: contacts[tag].contactName, contactNumber: contacts[tag].contactNumber, isCheck: true)
        if contacts[tag].isCheck {
            contacts[tag].isCheck=false
            contactsNameInCollectionView.remove(at: contactsNameInCollectionView.index(where: {$0.contactName==contacts[tag].contactName && $0.contactNumber==contacts[tag].contactNumber})!)
        }else{
            contacts[tag].isCheck=true
            contactsNameInCollectionView.append(data)
        }
        
        if filterItem.count>0{
            if filterItem[indexSearch].isCheck{
                filterItem[indexSearch].isCheck=false
            }else{
                filterItem[indexSearch].isCheck=true
            }
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
        cell?.layer.cornerRadius=5
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //selectedArray.remove(numberArray.object(at: contacts.index(where: {$0.contactNumber == contactsNameInCollectionView[indexPath.row].contactNumber})!))
        contacts[contacts.index(where: {$0.contactNumber == contactsNameInCollectionView[indexPath.row].contactNumber})!].isCheck=false
        contactsNameInCollectionView.remove(at: indexPath.row)
        tableViewFooter.reloadData()
        collectionViewHeader.reloadData()
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
            if mySelectedContact.contains(where: { $0.contactNumber == contacts[index].contactNumber }) {
                let data=DataContact(contactName: contacts[index].contactName, contactNumber: contacts[index].contactNumber, isCheck: true)
                contacts[index].isCheck=true
                contactsNameInCollectionView.append(data)
            }
        }
        DispatchQueue.main.async {
            self.tableViewFooter.reloadData()
            self.collectionViewHeader.reloadData()
        }
        processCircle.stopAnimating()
    }
    
    func errorContact() {
        showMessage(message: "No contact in your device, man!")
    }
}
