//
//  DisplayGpMembersTableViewController.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 17/04/23.
//

import UIKit

class DisplayGpMembersTableViewController: UITableViewController {
    
     var sectionContent:GroupModel?
    
    init(grpMembers:GroupModel){
        super.init(nibName: nil, bundle: nil)
        self.sectionContent = grpMembers
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = sectionContent?.groupName
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return (sectionContent?.data.count)!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (sectionContent?.data[section].rows.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        var name = sectionContent?.data[indexPath.section].rows[indexPath.row].firstName
        if sectionContent?.data[indexPath.section].rows[indexPath.row].lastName != nil{
            name! += "   \((sectionContent?.data[indexPath.section].rows[indexPath.row].lastName)!)"
        }
        cell?.textLabel?.text = name
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionContent?.data[section].sectionName
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        navigationController?.pushViewController(ProfilePageViewController(contact: (sectionContent?.data[indexPath.section].rows[indexPath.row])!), animated: true)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    }
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }

}
