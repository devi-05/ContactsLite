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

extension [[String:Any]]{
    func getIntList()->[Int]{
        var temp = [Int]()
        for i in self{
            for j in i{
                temp.append(Int(String(describing:j.value))!)
            }
        }
        return temp
    }
    func getStrList()->[String]{
        var temp = [String]()
        for i in self{
            for j in i{
                temp.append(j.value as? String ?? "")
            }
        }
        return temp
    }
}
