////
////  LocalDataSource.swift
////  ContactsLite
////
////  Created by devi-pt6261 on 16/04/23.
////
//
//import Foundation
//class LocalDataSource {
//    
//    static let shared = LocalDataSource()
//    
//    private init(){}
//    
//    lazy  var fetchedData = DBHelper.fetchData()
//    
////    lazy var favouriteContacts = DBHelper.fetchFavourites(colName: "FIRST_NAME", conditions: "IS_FAVOURITE = 1")
////    lazy var favContacts:[SectionContent] = []
//    
////    lazy var emergencyContacts = DBHelper.fetchEmergencyContact(colName:"FIRST_NAME",conditions: "IS_EMERGENCYCONTACT = 1")
////    lazy var emergencyContact:[SectionContent] = []
//    lazy var dbContactList:[Contacts] = Helper.decodeToContact(list: LocalDataSource.shared.fetchedData)
//
//    lazy var localDataSource:[SectionContent] = Helper.extractNamesFromFetchedData(lists: Helper.sort(data: dbContactList))
////    lazy var grpNames = DBHelper.fetchGrpNames(colName: "GROUP_NAME")
////    lazy var groupNames:[String] = ListTableViewController().getGrpNames(grpName: LocalDataSource.shared.grpNames)
////    
////    lazy var grpData:[SectionContent] = getGroupsData(grpName: LocalDataSource.shared.groupNames)
//
//
//    
//}
//
