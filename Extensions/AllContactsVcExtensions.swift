//
//  AllContactsVcExtensions.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 28/04/23.
//

import Foundation


extension Array where Element == SectionContent{
    func getTotalContacts()->Int{
        var count = 0
        for i in self{
            count+=i.rows.count
        }
        return count
    }
    func getContact(indexPath:IndexPath) -> Contact {
        self[indexPath.section].rows[indexPath.row]
    }
}
