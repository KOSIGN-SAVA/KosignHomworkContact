//
//  ContactPresenterInterface.swift
//  Read Contact
//
//  Created by Pha Vansa on 12/20/16.
//  Copyright © 2016 Pha Vansa. All rights reserved.
//

import Foundation

protocol ContactPresenterInterface {
    func responseMessage(msg:String)
    func startReadContact()
    func responseContact(contact: [DataContact])
    func errorContact()
}
