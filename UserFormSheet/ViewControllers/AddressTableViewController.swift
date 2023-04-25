//
//  AddressTableViewController.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 06/04/23.
//

import UIKit

class AddressTableViewController: UITableViewController {
    var delegate:Delegate?
    var options:[Int:[String]] = [0:["home","work","school","other"]]
    var selectedSecIndex:Int?
    var selectedRowIndex:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Label"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }



    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return options.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return options[section]!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = options[indexPath.section]?[indexPath.row]
        
        if (selectedSecIndex == indexPath.section && selectedRowIndex == indexPath.row){
            cell?.accessoryType = .checkmark
        }
        else{
            cell?.accessoryType = .none
        }
        return cell!
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }

    @objc func cancel(){
        dismiss(animated: true)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSecIndex = indexPath.section
        selectedRowIndex = indexPath.row
        tableView.reloadData()
        delegate?.getOptions(option: (options[indexPath.section]?[indexPath.row])!, type: Headers.address)
        cancel()
    }

}
