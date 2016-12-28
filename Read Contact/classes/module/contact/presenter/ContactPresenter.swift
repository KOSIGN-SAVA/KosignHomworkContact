//
//  ContactPresenter.swift
//  Read Contact
//
//  Created by Pha Vansa on 12/20/16.
//  Copyright © 2016 Pha Vansa. All rights reserved.
//

import Foundation
import Contacts

class ContactPresenter: ReaderContactInterface {
    
    var contact:ReaderContact?
    var reader:ContactPresenterInterface?
    
    init() {
        self.contact=ReaderContact()
        self.contact?.handleContact=self
    }
    
    func requestAccess(){
        self.contact?.requestForAccess(completionHandler: {(accessGranted) in
            if accessGranted {
                let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey]
                var contacts = [CNContact]()
                var listContacts=[DataContact]()
                var message: String!
                let contactsStore = CNContactStore()
                do {
                    try contactsStore.enumerateContacts(with: CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])) {
                        (contact, cursor) -> Void in
                        contacts.append(contact)
                        var con:DataContact!
                        
                        for phonenumber: CNLabeledValue in contact.phoneNumbers {
                            con=DataContact(contactName: contact.givenName, contactNumber: "\(phonenumber.value.value(forKey: "digits")!)", isCheck: false)
                            listContacts.append(con)
                        }
                    }
                    
                    //sent data back to presenter
                    self.readSuccess(contact: listContacts)
                    
                    if contacts.count == 0 {
                        message = "No contacts were found matching the given phone number."
                        self.exportString(st: message)
                    }
                }
                catch {
                    message = "Unable to fetch contacts."
                    self.exportString(st: message)
                }
            }
        })
    }
    
    func exportString(st: String) {
        self.reader?.responseMessage(msg: st)
    }
    
    func readSuccess(contact: [DataContact]) {
        self.reader?.responseContact(contact: contact)
    }
    
    func readError() {
        //
    }
    
}
