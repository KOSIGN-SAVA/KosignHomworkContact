//
//  MainContactTableViewController.swift
//  Read Contact
//
//  Created by Pha Vansa on 12/20/16.
//  Copyright © 2016 Pha Vansa. All rights reserved.
//

import UIKit

class MainContactTableViewController: UITableViewController {
    
    var presenter:ContactPresenter?
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter=ContactPresenter()
        self.presenter?.reader=self
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySelectedContact.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idtMainCell", for: indexPath)
        cell.textLabel?.text=mySelectedContact[indexPath.row].contactName
        cell.detailTextLabel?.text=mySelectedContact[indexPath.row].contactNumber
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            mySelectedContact.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

extension MainContactTableViewController:ContactPresenterInterface{
    
    func responseMessage(msg: String) {
        //
    }
    
    func startReadContact() {
        //
    }
    
    func responseContact(contact: [DataContact]) {
        //
    }
    
    func errorContact() {
        //
    }
    
}




























