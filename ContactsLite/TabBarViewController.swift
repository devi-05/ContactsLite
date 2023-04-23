//
//  TabBarViewController.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 29/03/23.
//

import UIKit

class TabBarViewController: UITabBarController{
    
    
    
//    lazy var sortedFavContacts:[SectionContent] = []
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        refreshFavData()
//    }
//
//    func refreshFavData(){
//        lazy var favContacts = DBHelper.fetchEmergencyContact(conditions: "IS_FAVOURITE = 1")
//        sortedFavContacts = Helper.extractNamesFromFetchedData(lists: Helper.sort(data: Helper.decodeToContact(list: (favContacts))))
//        print("sorted fav :\(sortedFavContacts)")
//    }
    override func viewDidLoad() {
//        let infovc = InfoSheetViewController(contact: nil)
//        infovc.tabvc = self
        super.viewDidLoad()
//        refreshFavData()
        let vc1 = UINavigationController(rootViewController: AllContactsVc(data: nil))
        let vc2 = UINavigationController(rootViewController: FavViewController())
        let vc3 = UINavigationController(rootViewController: EmergencyContactViewController())
        let vc4 = UINavigationController(rootViewController: ListTableViewController())
        
       
        vc2.title = "Favourites"
        vc3.title = "Emergency"
        vc4.title = "Groups"
        
        vc1.tabBarItem.image = UIImage(systemName: "person.crop.rectangle.stack.fill")
        vc2.tabBarItem.image = UIImage(systemName: "star.fill")
        vc3.tabBarItem.image = UIImage(systemName: "staroflife.fill")
        vc4.tabBarItem.image = UIImage(systemName: "person.3.fill")
        
        vc1.tabBarItem.image?.withTintColor(.label)
        vc2.tabBarItem.image?.withTintColor(.systemBlue)
        vc3.tabBarItem.image?.withTintColor(.systemRed)
        vc4.tabBarItem.image?.withTintColor(.label)
        
        setViewControllers([vc1,vc2,vc3,vc4], animated: false)
        
    }
    

    

}
