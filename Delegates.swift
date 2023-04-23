//
//  Delegates.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 22/04/23.
//

import Foundation
import UIKit

protocol Delegate{
    func getOptions(option:String,type:String)
}

protocol ImageDelegate{
    func getImage(images:UIImage)
}

protocol editDelegate{
    func getUpdatedContact(newContact:Contacts)
}
