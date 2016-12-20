//
//  ReaderContact.swift
//  Read Contact
//
//  Created by Pha Vansa on 12/20/16.
//  Copyright © 2016 Pha Vansa. All rights reserved.
//

import Foundation
import Contacts

class ReaderContact {
    
    var handleContact:ReaderContactInterface?
    
    //get data contact from iPhone
    func fectchContact() {
        
    }
    
    func requestForAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        // Get authorization
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)

        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
            
        case .denied, .notDetermined:
            CNContactStore().requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async(execute: { () -> Void in
                            let message = "\(accessError!.localizedDescription)\n\nYou can not use now, please click button below to setting permission. :)"
                            self.handleContact?.exportString(st: message)
                        })
                    }
                }
            })
            
        default:
            completionHandler(false)
        }
    }
    
}
