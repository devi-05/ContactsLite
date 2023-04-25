//
//  PhoneNumOptionsTableView.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 05/04/23.
//

import UIKit

class PhoneNumOptionsTableView: UITableViewController {
   
    var delegate:Delegate?
    var selectedRowIndex:Int?
    var selectedSectionIndex:Int?
    var Options : [Int:[String]] = [0:["mobile","home","work","school","iphone","Apple Watch","main","home fax","work fax","pager","other"]]
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        title = "Label"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(cancel))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Options.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Options[section]!.count
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = Options[indexPath.section]?[indexPath.row]
        if ( indexPath.section == selectedSectionIndex && indexPath.row == selectedRowIndex) {
                    cell?.accessoryType = .checkmark
                } else {
                    cell?.accessoryType = .none
                }
        
        return cell!
    }
    @objc func cancel(){
        dismiss(animated: true)
    }
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSectionIndex = indexPath.section
        selectedRowIndex = indexPath.row
        tableView.reloadData()
        delegate?.getOptions(option: (Options[indexPath.section]?[indexPath.row])!,type: Headers.phoneNumber)
        cancel()
        
    }
    
}
