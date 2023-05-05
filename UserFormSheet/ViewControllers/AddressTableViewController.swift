//
//  AddressTableViewController.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 06/04/23.
//

import UIKit

class AddressTableViewController: UITableViewController {
    weak var delegate:Delegate?
    var selectedOption:String?
    var options:[String] = ["home","work","school","other"]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Label"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    init(selectedOption:String){
        self.selectedOption = selectedOption
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = options[indexPath.row]
        
        if (options[indexPath.row] == selectedOption ){
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
       
        tableView.reloadData()
        delegate?.getOptions(option: (options[indexPath.row]), type: Headers.address)
        cancel()
    }
    override func viewWillDisappear(_ animated: Bool) {
        delegate = nil
    }

}
