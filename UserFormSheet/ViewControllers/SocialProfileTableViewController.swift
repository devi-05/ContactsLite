//
//  SocialProfileTableViewController.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 07/04/23.
//

import UIKit

class SocialProfileTableViewController: UITableViewController {
    
    weak var delegate:Delegate?
    
    var selectedOption:String?
    
    var options:[String] = ["Twitter","Facebook","Flickr","LinkedIn","MySpace"]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(Cancel))
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
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if(options[indexPath.row] == selectedOption){
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
    @objc func Cancel(){
        dismiss(animated: true)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   

        delegate?.getOptions(option: (options[indexPath.row]), type: Headers.socialProfile)
        tableView.reloadData()
        Cancel()
    }
    override func viewWillDisappear(_ animated: Bool) {
        delegate = nil
    }
}
