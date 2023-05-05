//
//  Delegates.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 22/04/23.
//

import Foundation
import UIKit

protocol Delegate:AnyObject{
    func getOptions(option:String,type:String)
}

protocol ImageDelegate:AnyObject{
    func getImage(images:UIImage)
}

protocol EditDelegate: AnyObject {
    func getUpdatedContact(newContact:Contact)
}


