//
//  UserFormSheetModels.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 09/04/23.
//

import Foundation




enum Headers{
    static var contactId = "Contact Id"
    static var profileImage = "Profile Image"
    static var firstName = "First Name"
    static var lastName = "Last Name"
    static var workInfo = "Work Info"
    static var phoneNumber = "Phone Number"
    static var email = "Email"
    static var address = "Address"
    static var socialProfile = "Social Profile"
    static var favourite = "Favourite"
    static var emergencyContact = "Emergency Contact"
    static var notes = "Notes"
    static var groups = "Groups"
}

struct Contacts{
    var contactId:Int
    var profileImage:Data?
    var firstName:String
    var lastName:String?
    var workInfo:String?
    var phoneNumber:[PhoneNumberModel]
    var email:[String]?
    var address:[AddressModel]?
    var socialProfile:[SocialProfileModel]?
    var favourite:Int?
    var emergencyContact:Int?
    var notes:String?
    var groups:[String]?
    
    
    func fullName() -> String {
        return firstName + (lastName ?? "")
    }
    
}

struct SectionContent{
    let sectionName : String
    var rows: [Contacts]
}
struct GroupModel{
    var groupName:String
    var data:[SectionContent]
}
struct DataSource{
    var data:[String]
}
struct PhoneNumberModel:Codable{
    var modelType:String
    var number:Int64?
}

struct SocialProfileModel:Codable{
    var profileType:String
    var link:String?
}

struct AddressModel:Codable{
    var modelType:String
    var doorNo:String?
    var Street:String?
    var city:String?
    var postcode:String?
    var state:String?
    var country:String?
}


var dbPointer:OpaquePointer?






//struct Section{
//    var title:String
//    var rows:[Row]
//}
//struct Row{
//    var rowTitle:String
//    var cellType:UITableViewCell.Type
//}
//
//var Ds:[Section] = [Section(title: "", rows:[ Row(rowTitle: Headers.firstName,cellType: ContactNameTableViewCell.self),Row(rowTitle: Headers.lastName, cellType: ContactNameTableViewCell.self)]),Section(title: Headers.workInfo, rows: [Row(rowTitle: Headers.workInfo, cellType: AddTableViewCell.self)]),Section(title: Headers.phoneNumber, rows: [Row(rowTitle:"phone", cellType: PhoneNumberTableViewCell.self)]),Section(title: Headers.email, rows: [Row(rowTitle: Headers.email, cellType: AddTableViewCell.self)]),Section(title: Headers.address, rows: [Row(rowTitle: "", cellType: AddressTableViewCell.self)]),Section(title: Headers.socialProfile, rows: [Row(rowTitle: Headers.socialProfile, cellType: AddTableViewCell.self)]),Section(title: Headers.favourite, rows: [Row(rowTitle: "", cellType: FavouriteAndEmergencyContactTableViewCell.self)]),Section(title: Headers.emergencyContact, rows: [Row(rowTitle: "", cellType: FavouriteAndEmergencyContactTableViewCell.self)]),Section(title: Headers.notes, rows: [Row(rowTitle: Headers.notes, cellType: NotesTableViewCell.self)]),Section(title: Headers.groups, rows: [Row(rowTitle: "", cellType: GroupsTableViewCell.self)])
