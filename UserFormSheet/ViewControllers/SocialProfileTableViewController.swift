//
//  SocialProfileTableViewController.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 07/04/23.
//

import UIKit

class SocialProfileTableViewController: UITableViewController {
    
    var delegate:Delegate?
    
    var selectedSecIndex:Int?
    
    var selectedRowIndex:Int?
    
    var options:[Int:[String]] = [0:["Twitter","Facebook","Flickr","LinkedIn","MySpace"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(Cancel))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return options.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return options[section]!.count
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if(selectedSecIndex == indexPath.section && selectedRowIndex == indexPath.row){
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        cell.textLabel?.text = options[indexPath.section]?[indexPath.row]
        return cell
    }
    
    @objc func Cancel(){
        dismiss(animated: true)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSecIndex = indexPath.section
        selectedRowIndex = indexPath.row
        tableView.reloadData()
        print(options[indexPath.section]?[indexPath.row] as Any)
        delegate?.getOptions(option: (options[indexPath.section]?[indexPath.row])!, type: Headers.socialProfile)
        Cancel()
    }

}
