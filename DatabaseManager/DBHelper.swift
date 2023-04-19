//
//  DBHelper.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 07/04/23.
//
//class Phone:Codable{
//    var type:String
//    var number:Int
//    init(type: String, number: Int) {
//        self.type = type
//        self.number = number
//    }
//}
//
//class Address:Codable {
//    var type:String
//    var doorNum:Int
//    init(type: String, doorNum: Int) {
//        self.type = type
//        self.doorNum = doorNum
//    }
//
//}
import Foundation

struct DBHelper {
    static var dbManager = DatabaseManager.shared
    
     static func prepare() {
        dbManager.createDb(location: .documentDirectory, path: "Contactsdb.sqlite")
    }
    static func createTable(){ 
        dbManager.commonCreateTableFunc(query: "CREATE TABLE IF NOT EXISTS CONTACTS (CONTACT_ID INTEGER PRIMARY KEY,PROFILE_PHOTO BLOB,FIRST_NAME TEXT,LAST_NAME TEXT, WORK_INFO TEXT,PHONENUMBER TEXT,EMAIL TEXT,ADDRESS TEXT,SOCIAL_PROFILE TEXT,IS_FAVOURITE INT,IS_EMERGENCYCONTACT INT,NOTES TEXT)", tableName: "CONTACTS")
        dbManager.commonCreateTableFunc(query: "CREATE TABLE IF NOT EXISTS GROUPS (GROUP_ID INTEGER PRIMARY KEY,GROUP_NAME TEXT)", tableName: "GROUPS")
        dbManager.commonCreateTableFunc(query: "CREATE TABLE IF NOT EXISTS CONTACTS_AND_GROUPS (CONTACT_ID INT,GROUP_ID INT)", tableName: "CONTACTS_AND_GROUPS")
        
        UserDefaults.standard.set("YES", forKey: "IS_TABLECOLUMNS_CREATED")
    }
    static func assignDb(contactList:Contacts){
        prepare()
        dbManager.Insert(tableName: "CONTACTS", listOfValToBeAppended: [["CONTACT_ID":contactList.contactId,"PROFILE_PHOTO":(contactList.profileImage) ?? nil,"FIRST_NAME":contactList.firstName,"LAST_NAME":(contactList.lastName) ?? "","WORK_INFO":(contactList.workInfo)!,"PHONENUMBER":convertListToString(list: phoneNumEncoder(phoneNumList: contactList.phoneNumber)),"EMAIL":convertListToString(list: (contactList.Email)!),"ADDRESS":convertListToString(list: addressEncoder(addressList: (contactList.address)!)),"SOCIAL_PROFILE":convertListToString(list: socialProfileEncoder(socialProfList:(contactList.socialprofile)!)),"IS_FAVOURITE":(contactList.favourite)!,"IS_EMERGENCYCONTACT":(contactList.emergencyContact)!,"NOTES":(contactList.notes) ?? ""]])
        let dateformat = DateFormatter()
        dateformat.dateFormat = "mmss"
        guard let myInt = Int(dateformat.string(from: Date()))  else {
            print("Conversion failed.")
            return
        }
      
        if(convertListToString(list: contactList.groups!) == ""){
            return
        }
        else{

            print(contactList.groups!)
            for i in contactList.groups!{
                
                
                let grpId = dbManager.fetch(tableName: "GROUPS", colList: ["GROUP_ID"], conditions: "GROUP_NAME = '\(i)'")
                for j in grpId{
                    for k in j{
                        dbManager.Insert(tableName: "CONTACTS_AND_GROUPS", listOfValToBeAppended: [["CONTACT_ID":contactList.contactId,"GROUP_ID":Int(String(describing:k.value))!]])
                        
                    }
                }
            }
            
}
    }
    static func fetchData()->[[String:Any]]{
        prepare()
        return dbManager.fetch(tableName: "CONTACTS", colList: nil, conditions: nil)
        
    }
    
    static func delete(criteria:String?){
        prepare()
        dbManager.deleteRow(tableName: "CONTACTS", criteria: criteria)
    }
    
    static func phoneNumEncoder(phoneNumList:[PhoneNumberModel])->[String]{
        var temp:[String] = []
        
        for i in phoneNumList {
            
                let encodedData = try! JSONEncoder().encode(i)

                let string = String(data: encodedData, encoding: .utf8)
            
                temp.append(string!)
            
            }
        return temp
    }
    static func addressEncoder(addressList:[AddressModel])->[String]{
        var temp:[String] = []
        for i in addressList {
            
                let encodedData = try! JSONEncoder().encode(i)

                let string = String(data: encodedData, encoding: .utf8)
       
            temp.append(string!)
            
            }
        return temp
    }
    static func socialProfileEncoder(socialProfList:[SocialProfileModel])->[String]{
        var temp:[String] = []
        for i in socialProfList {
            
                let encodedData = try! JSONEncoder().encode(i)

                let string = String(data: encodedData, encoding: .utf8)
                temp.append(string!)
            
            }
        return temp
    }
    
//    func encoderrr<T:Phone,U:Address>(listOfObj:([T],[U]))->[[String]] {
//        var arrList:[[String]] = []
//        var temp:[String] = []
//        var temp2:[String] = []
//        for i in listOfObj.0 {
//
//                let encodedData = try! JSONEncoder().encode(i)
//
//                let string = String(data: encodedData, encoding: .utf8)
//            temp.append(string!)
//
//            }
//        arrList.append(temp)
//        for j in listOfObj.1 {
//            let encodedData = try! JSONEncoder().encode(j)
//
//            let string = String(data: encodedData, encoding: .utf8)
//            temp2.append(string!)
//
//        }
//        arrList.append(temp2)
//        return arrList
//    }
    
    static func phoneNumDecoder(str:String)->[PhoneNumberModel] {
        var temp:[PhoneNumberModel] = []
        
        
        let encodedData = Data(str.utf8)
        let decodedData = try! JSONDecoder().decode(PhoneNumberModel.self, from: encodedData)
        temp.append(decodedData)
        
        return temp
    }
    static func addressDecoder(str:String)->[AddressModel] {
        var temp:[AddressModel] = []
        
        let encodedData = Data(str.utf8)
        let decodedData = try! JSONDecoder().decode(AddressModel.self, from: encodedData)
        temp.append(decodedData)
        
        return temp
    }
    static func socialProfileDecoder(str:String)->[SocialProfileModel] {
        var temp:[SocialProfileModel] = []
        
        
        let encodedData = Data(str.utf8)
        let decodedData = try! JSONDecoder().decode(SocialProfileModel.self, from: encodedData)
        temp.append(decodedData)
        
        return temp
    }
    

    static func fetchFavourites(colName:String,conditions:String)->[[String:Any]]{
        prepare()
       return dbManager.fetch(tableName: "CONTACTS", colList: [colName], conditions: conditions)
    }
    static func fetchEmergencyContact(conditions:String)->[[String:Any]]{
        prepare()
       return dbManager.fetch(tableName: "CONTACTS", colList: nil, conditions: conditions)
    }
    static func fetchGrpNames(colName:String)->[[String:Any]]{
        prepare()
        
       return dbManager.fetch(tableName: "GROUPS", colList: [colName], conditions:nil)
    }
    
    static func fetchGroupMembers(groupName:String)->[Contacts]{
        print("grpname; \(groupName)")
        var contactLists:[[Contacts]] = []
        prepare()
        let groupId = dbManager.fetch(tableName: "GROUPS", colList: ["GROUP_ID"], conditions: "GROUP_NAME = '\(groupName)'")
        print("groupId:\(groupId)")
        var values:[Int] = []
        for i in groupId{
            for j in i{
                    values.append(Int(String(describing:j.value))!)
                }
            
        }
       print("values:\(values)")
        for j in values{
            let contactId = dbManager.fetch(tableName: "CONTACTS_AND_GROUPS", colList: ["CONTACT_ID"], conditions: "GROUP_ID = \(j)")
            print("contactId \(contactId)")
            for i in contactId{
                for k in i{
                    let value = dbManager.fetch(tableName: "CONTACTS", colList: nil, conditions: "CONTACT_ID = \(k.value)")
                    print("val:\(value)")
                    contactLists.append(Helper.decodeToContact(list: value))
                }
            }
           
        }
       
        return contactLists.flatMap({$0})
    }
    static func addGroup(grpName:String,grpId:Int){
        prepare()
        dbManager.Insert(tableName: "GROUPS", listOfValToBeAppended: [["GROUP_ID":grpId,"GROUP_NAME":grpName]])
    }
    static func convertListToString(list:[String])->String {
        
        return list.joined(separator: ";")
    }
    static func convertStringToList(str:String)->[String] {
        return str.components(separatedBy: ";")
    }
    
    static func deleteGroup(grpName:String){
        prepare()
        let grpIdList = dbManager.fetch(tableName: "GROUPS", colList: ["GROUP_ID"], conditions: "GROUP_NAME = '\(grpName)'")
        var grpId:Int?
        for i in grpIdList{
            for j in i{
                grpId = Int(String(describing:j.value ))
            }
        }
        dbManager.deleteRow(tableName: "GROUPS", criteria: "GROUP_NAME = '\(grpName)'")
        dbManager.deleteRow(tableName: "CONTACTS_AND_GROUPS", criteria: "GROUP_ID = \(grpId!)")
    }
    static func updateGrpName(existingGrpName:String,newGrpName:String){
        prepare()
        dbManager.update(tableName: "GROUPS", colListWithVal: ["GROUP_NAME" : (newGrpName)], criteria: "GROUP_NAME = '\(existingGrpName)'")
    }
    static func fetchSortedData(tableName:String,colName:[String]?,criteria:[String],sortPreference:String)->[[String : Any]]{
        prepare()
        return dbManager.orderBy(tableName: tableName, colNames: colName, criteria: criteria, sortPreference: sortPreference)
    }
}
