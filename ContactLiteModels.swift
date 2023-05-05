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
enum HeaderNames:CaseIterable{
    case contactId,profileImage,firstName,lastName,workInfo,phoneNumber,email,address,socialProfile,groups,notes,favourite,emergencyContact
}

class Contact{
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
    
    init(contactId: Int, profileImage: Data? = nil, firstName: String, lastName: String? = nil, workInfo: String? = nil, phoneNumber: [PhoneNumberModel], email: [String]? = nil, address: [AddressModel]? = nil, socialProfile: [SocialProfileModel]? = nil, favourite: Int? = nil, emergencyContact: Int? = nil, notes: String? = nil, groups: [String]? = nil) {
        self.contactId = contactId
        self.profileImage = profileImage
        self.firstName = firstName
        self.lastName = lastName
        self.workInfo = workInfo
        self.phoneNumber = phoneNumber
        self.email = email
        self.address = address
        self.socialProfile = socialProfile
        self.favourite = favourite
        self.emergencyContact = emergencyContact
        self.notes = notes
        self.groups = groups
    }
    
    func fullName() -> String {
        return firstName + " " + (lastName ?? "")
    }
    
}

struct SectionContent{
    let sectionName : String
    var rows: [Contact]
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

var appFilePath:URL?
