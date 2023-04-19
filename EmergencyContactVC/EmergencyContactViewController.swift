//
//  EmergencyContactViewController.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 14/04/23.
//

import UIKit

protocol EmergencyContactDelegate{
    func addToEmergency(contact:Contacts)
}
class EmergencyContactViewController: UITableViewController
{

   
    var temp:[String] = []
    lazy var emergencyContacts:[[String : Any]] = []
    lazy var sortedEmergencyContacts:[SectionContent] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emergencyContacts = DBHelper.fetchEmergencyContact(conditions: "IS_EMERGENCYCONTACT = 1")
        sortedEmergencyContacts = Helper.extractNamesFromFetchedData(lists: Helper.sort(data: Helper.decodeToContact(list: (emergencyContacts))))
        tableView.reloadData()
    }
    override func viewDidLoad() {
        
        title = "Emergency Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sortedEmergencyContacts.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedEmergencyContacts[section].rows.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        var name:String = sortedEmergencyContacts[indexPath.section].rows[indexPath.row].firstName
        if(sortedEmergencyContacts[indexPath.section].rows[indexPath.row].lastName != nil){
            name += " \( (sortedEmergencyContacts[indexPath.section].rows[indexPath.row].lastName)!)"
        }
        cell?.textLabel?.text = name
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("\(sortedEmergencyContacts[indexPath.section].rows[indexPath.row].firstName) is selected" )
        let vc = ProfilePageViewController(contact: sortedEmergencyContacts[indexPath.section].rows[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedEmergencyContacts[section].sectionName
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    }
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    
    
    
}

   


