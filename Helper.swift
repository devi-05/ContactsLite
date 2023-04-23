//
//  Helper.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 18/04/23.
//

import Foundation

class Helper{
    static func sort(data:[Contacts])->[Contacts]{
        
        
        
        var contacts:[Contacts] = []
        
        contacts += (data.sorted(by: {$0.firstName < $1.firstName}))
        return contacts
        
    }
    static func extractNamesFromFetchedData(lists:[Contacts])->[SectionContent]{
        
        var sectionData:[SectionContent] = []
        var data:[SectionContent] = []
        var isHash = true
        var hashSectionContent:SectionContent?
        var firstLetter:String = ""
        for i in lists{
            let name =  i.firstName
            if let firstName = name.first {
                 firstLetter = String(firstName)
            }
            let alphabets = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
            if (!alphabets.description.lowercased().contains(firstLetter.lowercased())){
//            if (!CharacterSet.lowercaseLetters.contains(firstLetter.lowercased().unicodeScalars.first!)){
                if(isHash){
                    firstLetter = "#"
                    hashSectionContent = SectionContent(sectionName: "#", rows: [i])
                    isHash = false
                }
                else{
                    hashSectionContent?.rows.append(i)
                }
            }
            else{
            
            if(sectionData.isEmpty){
                sectionData.append(SectionContent(sectionName: firstLetter, rows: [i]))
            }
                else{
                    var bool:Bool = false
                    for j in 0..<sectionData.count {
                        print("datasource count:\(sectionData.count)")
                        if sectionData[j].sectionName == firstLetter {
                            sectionData[j].rows.append(i)
                            bool = true
                        }
                    }
                    if(bool == false){
                        sectionData.append(SectionContent(sectionName: firstLetter, rows: [i]))
                    }
                    
                }
            }
            
            
             data = sectionData.sorted(by: {$0.sectionName < $1.sectionName})
            
        }
        if(hashSectionContent != nil){
            data.append(hashSectionContent!)
        }
        
        return data
    }
    
    static func getGroupsData(locDS:[SectionContent],grpName:[String])->[GroupModel]{
        var groups:[GroupModel]=[]
        var localDbContactList:[Contacts] = []
        for i in locDS{
                    for j in i.rows{
                        localDbContactList.append(j)
                    }
                }
        if (!localDbContactList.isEmpty){
                groups.append(GroupModel(groupName: "iPhone", data:
                                            [SectionContent(sectionName: "iPhone", rows: localDbContactList)]))
                               }
        else{
            groups.append(GroupModel(groupName: "iPhone", data:
                                        []))
                           }
        
        
        print(grpName)
        for i in grpName{
            
            var data:[SectionContent] = []
            print("fetch \(DBHelper.fetchGroupMembers( groupName: i))")
            data = extractNamesFromFetchedData(lists:sort(data: DBHelper.fetchGroupMembers( groupName: i)))
            print(data)
            groups.append(GroupModel(groupName: i, data: data))
            
            
        }
        print("model \(groups)")
        return groups
    }
    static func getGrpNames(grpName:[[String:Any]])->[String]{
        print(grpName)
        var groups:[[String]]=[]
        var grp:[String] = []
        for i in grpName{
            for j in i {
                groups.append(String(describing: j.value).components(separatedBy: ";"))
            }
        }
        print("groups:\(groups)")
        for i in groups{
            for j in i{
                if (!grp.contains(j)){
                    grp.append(String(describing: j))
                }
            }
        }
        print("grp\(grp)")
        return grp
    }
    static func decodeToContact(list:[[String:Any]])->[Contacts]{
        var id:Int = 0
        var image:Data?
        var firstName:String = ""
        var lastName:String?
        var workInfo:String?
        var emailArray:[String] = []
        var isFavourite:Int = 0
        var isEmergencyContact:Int = 0
        var notes:String?
        var groups:[String] = []
        var phoneNum:[PhoneNumberModel] = []
        var address:[AddressModel] = []
        var socialProfile:[SocialProfileModel] = []
        var ds:[Contacts] = []
        
        for i in list{
            for j in i{
                switch j.key{
                case "CONTACT_ID":
                    id = Int(String(describing: j.value))!
                case "PROFILE_PHOTO":
                    image =  (j.value as! Data)
                case "FIRST_NAME":
                    firstName = String(describing:j.value)
                case "LAST_NAME":
                    lastName = String(describing: j.value)
                case "WORK_INFO":
                    workInfo = String(describing: j.value)
                case "PHONENUMBER":
                    phoneNum = DBHelper.phoneNumDecoder(str: j.value as! String)
                case "EMAIL":
                    emailArray = DBHelper.convertStringToList(str: String(describing: j.value))
                case "ADDRESS":
                    address = DBHelper.addressDecoder(str: String(describing: j.value))
                case "SOCIAL_PROFILE":
                    socialProfile = DBHelper.socialProfileDecoder(str: String(describing: j.value))
                case "IS_FAVOURITE":
                    isFavourite = Int(String(describing: j.value))!
                case "IS_EMERGENCYCONTACT":
                    isEmergencyContact = Int(String(describing: j.value))!
                case "NOTES":
                    notes = String(describing: j.value)
                default:
                    groups = DBHelper.convertStringToList(str:String(describing: j.value))
                }
                
            }
            ds.append(Contacts(contactId: id,profileImage: image, firstName: firstName,lastName: lastName,workInfo: workInfo, phoneNumber: phoneNum,email: emailArray,address: address,socialProfile: socialProfile,favourite: isFavourite,emergencyContact: isEmergencyContact,notes: notes,groups: groups))
            
        }
        
        
        return ds
    }
    
    
    
}
