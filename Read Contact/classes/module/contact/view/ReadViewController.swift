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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewFooter.delegate=self
        tableViewFooter.dataSource=self
        self.presenter=ContactPresenter()
        self.presenter?.reader=self
        self.presenter?.requestAccess()
        tableViewFooter.setEditing(true, animated: true)
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
        let cell=tableViewFooter.dequeueReusableCell(withIdentifier: "idtReqCell", for: indexPath)
        cell.textLabel?.text=contacts[indexPath.row].contactName
        cell.detailTextLabel?.text=contacts[indexPath.row].contactNumber
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
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
        print("My contact: \(contact)")
        self.contacts=contact
        DispatchQueue.main.async {
            self.tableViewFooter.reloadData()
        }
    }
    
    func errorContact() {
        //
    }
}
