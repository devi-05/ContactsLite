//
//  FavViewController.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 14/04/23.
//

import UIKit

protocol FavDeleagte{
    func addToFav(contact:Contacts)
}
class FavViewController: UITableViewController {
    
    var temp:[String] = []
    
    lazy var favContacts:[[String : Any]] = []
    lazy var sortedFavContacts:[SectionContent] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favContacts = DBHelper.fetchEmergencyContact(conditions: "IS_FAVOURITE = 1")
        sortedFavContacts = Helper.extractNamesFromFetchedData(lists: Helper.sort(data: Helper.decodeToContact(list: (favContacts))))
        tableView.reloadData()
    }
    override func viewDidLoad() {
        
       

        
        title = "Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sortedFavContacts.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedFavContacts[section].rows.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        var name:String = sortedFavContacts[indexPath.section].rows[indexPath.row].firstName
        if(sortedFavContacts[indexPath.section].rows[indexPath.row].lastName != nil){
            name += " \( (sortedFavContacts[indexPath.section].rows[indexPath.row].lastName)!)"
        }
        cell?.textLabel?.text = name
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("\(sortedFavContacts[indexPath.section].rows[indexPath.row].firstName) is selected" )
        let vc = ProfilePageViewController(contact: sortedFavContacts[indexPath.section].rows[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedFavContacts[section].sectionName
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    }
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
   
}
