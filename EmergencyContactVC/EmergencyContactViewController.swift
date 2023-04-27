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
    lazy var containerView:UIView = {
        let view = UIView()
        return view
    }()
    lazy var imageView:UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "light.beacon.min.fill")
        imgView.tintColor = .systemRed.withAlphaComponent(0.9)
        return imgView
    }()
    lazy var msgLabel:UILabel = {
       let label = UILabel()
        label.text = "No Emergency Contacts added yet !"
        label.textColor = .label.withAlphaComponent(0.7)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
   
    var temp:[String] = []
    lazy var emergencyContacts:[[String : Any]] = []
    lazy var sortedEmergencyContacts:[SectionContent] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Emergency Contacts"
       refreshEmergencyData()
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.reloadData()
    }
    func refreshEmergencyData(){
        emergencyContacts = DBHelper.fetchEmergencyContact(conditions: "IS_EMERGENCYCONTACT = 1")
        sortedEmergencyContacts = Helper.extractNamesFromFetchedData(lists: Helper.sort(data: Helper.decodeToContact(list: (emergencyContacts))))
        if(sortedEmergencyContacts.isEmpty){
            tableView.backgroundView = containerView
        }
        else{
            tableView.backgroundView = nil
        }
    }
    override func viewDidLoad() {
        
        
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        containerView.addSubview(imageView)
        containerView.addSubview(msgLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        msgLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            
            msgLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            msgLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 50),
            msgLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -50),
            msgLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(identifier: nil,previewProvider: nil){ _ in
            let edit = UIAction(title:"Remove from Emergency Contacts",image: UIImage(systemName: "multiply.circle"),identifier:nil,discoverabilityTitle: nil,state: .off){ _ in

                self.sortedEmergencyContacts[indexPath.section].rows[indexPath.row].emergencyContact = 0
                DBHelper.updateContact(contact: self.sortedEmergencyContacts[indexPath.section].rows[indexPath.row])
                self.refreshEmergencyData()
                tableView.reloadData()
            }
            let delete = UIAction(title:"Delete Contact",image: UIImage(systemName: "trash"),identifier:nil,discoverabilityTitle: nil,attributes:.destructive,state: .off){ _ in
                self.sortedEmergencyContacts[indexPath.section].rows[indexPath.row].emergencyContact = 0
                DBHelper.updateContact(contact: self.sortedEmergencyContacts[indexPath.section].rows[indexPath.row])
               
                DBHelper.deleteContact(contactId: self.sortedEmergencyContacts[indexPath.section].rows[indexPath.row].contactId)
                self.refreshEmergencyData()
                tableView.reloadData()

            }
            let view = UIAction(title:"View Profile",image: UIImage(systemName: "person.circle"),identifier:nil,discoverabilityTitle: nil,state: .off){ _ in
                
                let vc = ProfilePageViewController(contact: self.sortedEmergencyContacts[indexPath.section].rows[indexPath.row])
                self.navigationController?.pushViewController(vc, animated: true)

            }
            
            return UIMenu(title: "",image: nil,identifier: nil,children: [edit,view,delete])
        }
        return config
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
//        title = ""
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
        return 50
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {

        
        if sortedEmergencyContacts.count < 6 {
            return nil
        }
        else{
            return ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"]
        }
    }
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
  
        
        let sectionHeaders = sortedEmergencyContacts.map({$0.sectionName})
        
        if let ind = sectionHeaders.firstIndex(of: title){
            print(ind)
            return ind
        }
        else{
            var ind = 0
            for i in 0..<sectionHeaders.count{
                if sectionHeaders[i] < title {
                    ind = i
                }
            }
            print(ind)
            return ind
        }
        
    }
    
    
    
}

   


