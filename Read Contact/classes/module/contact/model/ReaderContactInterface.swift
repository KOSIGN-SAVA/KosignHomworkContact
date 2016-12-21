//
//  ReaderContactInterface.swift
//  Read Contact
//
//  Created by Pha Vansa on 12/20/16.
//  Copyright © 2016 Pha Vansa. All rights reserved.
//

import Foundation

protocol ReaderContactInterface {
    func exportString(st:String)
    func readSuccess(contact:[DataContact])
    func readError()
}

var mySelectedContact:[DataContact]=[]
