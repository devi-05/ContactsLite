//
//  ListTableViewController.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 09/04/23.
//

import UIKit


class ListTableViewController: UITableViewController {
    // previous data that are yet to be edited
    var dataToBeEdited: String = ""
    // isAddTapped -> to create textfield
    var isAddTapped:Bool = false
    // isEdited -> to perform edit actions in textfieldDidEndEditing
    var isEdited:Bool = false
    var rowToBeEdited = -1
    lazy var grpData:[GroupModel] = []
    lazy var grpNames:[[String:Any]] = []
    
    lazy var containerView:UIView = {
        let view = UIView()
        return view
    }()
    
   
    override init(style: UITableView.Style) {
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureDataSource()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureDataSource()
    }
    
    private func configureView() {
        title = "Lists"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addList))
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(CustomListTableViewCell.self, forCellReuseIdentifier: CustomListTableViewCell.identifier)
        tableView.register(CustomListTableViewCell1.self, forCellReuseIdentifier: CustomListTableViewCell1.identifier)
        
        tableView.keyboardDismissMode = .onDrag
    }
    
    private func configureDataSource(){
        let fetchedData = DBHelper.fetchData()
        let dbContactList = Helper.decodeToContact(list: fetchedData)
        let localDataSource = Helper.extractNamesFromFetchedData(lists: Helper.sort(data: dbContactList))
        grpNames = DBHelper.fetchGrpNames(colName: "GROUP_NAME")
        let groupNames:[String] = Helper.getGrpNames(grpName: grpNames)
        grpData = Helper.getGroupsData(locDS: localDataSource, grpName: groupNames)
        if(grpData.count > 1){
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(edit))
        }
    }
    private func editFunctionalities(row:Int){
        self.isEdited = true
        self.dataToBeEdited = self.grpData[row].groupName
        self.rowToBeEdited = row
        tableView.reloadData()
    }
    
    private func deleteFunctionalities(row:Int){
        let alertController = UIAlertController(title: "", message: "Are you sure you want to delete the list ' \(self.grpData[row].groupName)'?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let delAction = UIAlertAction(title: "Delete",style:.destructive) { _ in
            
            DBHelper.deleteGroup(grpName: self.grpData[row ].groupName)
            self.grpData.remove(at: row)
            if(self.grpData.count == 1){
                
                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),style: .plain, target: self, action: #selector(self.addList))
            }
            
            self.tableView.reloadData()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(delAction)
        self.present(alertController, animated: true)
    }
    
    
    @objc private func edit(){

        // here isaddtapped is assigned as false becaue when new cell is creared when add tapped and at the same tym edit is tapped the empty cell will be removed
        isAddTapped = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        tableView.setEditing(true, animated: true)
        tableView.reloadData()
    }
    
    @objc private func addList(){
        isAddTapped = true
        rowToBeEdited = grpData.count
        tableView.reloadData()
    }
    
    @objc private func done(){
        tableView.setEditing(false, animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(edit))
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.row == 0 || isAddTapped){
            return false
        }
        else{
         
                return true
            }
        
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        if(isAddTapped){
            return  grpData.count+1
        }
        
        else{
            return  grpData.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (rowToBeEdited == indexPath.row ){
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomListTableViewCell.identifier) as? CustomListTableViewCell
            cell?.textField.placeholder = "List Name"
            cell?.textField.becomeFirstResponder()
            if(!dataToBeEdited.isEmpty){
                cell?.textField.text = dataToBeEdited }
            cell?.textField.delegate = self
            return cell!
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomListTableViewCell1.identifier) as? CustomListTableViewCell1
            
            if(indexPath.row < grpData.count){
                if (!grpData[indexPath.row].groupName.isEmpty){
                    
                    cell?.label1.text = grpData[indexPath.row].groupName
                    cell?.label2.text =  (indexPath.row == 0) ? (grpData[indexPath.row].data.count == 0 ? (String(grpData[indexPath.section].data.count)) : String(grpData[indexPath.section].data[0].rows.count)):(grpData[indexPath.row].data.count == 0 ) ? (String(grpData[indexPath.row].data.count)) : (String(grpData[indexPath.row].data[0].rows.count))
                }
            }
            
            return cell!
        }
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if(indexPath.row != 0 && indexPath.row < grpData.count){
            let editAction = UIContextualAction(style: .normal,
                                                title: "Edit")
            { (action, view, completionHandler) in
                
                self.editFunctionalities(row: indexPath.row)
            }
            editAction.backgroundColor = .systemBlue
            let delAction = UIContextualAction(style: .normal,
                                               title: "Delete")
            {  (action, view, completionHandler) in
                
                self.deleteFunctionalities(row: indexPath.row)
            }
            delAction.backgroundColor = UIColor(red: 227/255, green: 51/255, blue: 39/255, alpha: 1)
            return UISwipeActionsConfiguration(actions: [delAction,editAction])
        }
        else{
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            let vc = AllContactsVc(grpName: grpData[indexPath.row].groupName)
            navigationController?.pushViewController(vc, animated: true)
    }
    
    // long press gesture actions
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if(indexPath.row == 0){
            return nil
        }
        let config = UIContextMenuConfiguration(identifier: nil,previewProvider: nil){ _ in
            let edit = UIAction(title:"Edit",image: UIImage(systemName: "pencil"),identifier:nil,discoverabilityTitle: nil,state: .off){ _ in
                self.view.endEditing(true)
                self.editFunctionalities(row: indexPath.row)
            }
            let delete = UIAction(title:"Delete",image: UIImage(systemName: "trash"),identifier:nil,discoverabilityTitle: nil,attributes:.destructive,state: .off){ _ in
                print("del")
                
                self.deleteFunctionalities(row: indexPath.row)
            }
            
            return UIMenu(title: "",image: nil,identifier: nil,children: [edit,delete])
        }
        return config
    }
    
    
   // if tapped outside it resigns first responder
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }
    
}

extension ListTableViewController:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "ddhhss"
        guard let myInt = Int(dateformat.string(from: Date()))  else {
            print("Conversion failed.")
            return
        }
        if (!textField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isEdited){
            grpData.append(GroupModel(groupName: textField.text!, data: []))
            DBHelper.addGroup(grpName: textField.text!, grpId: myInt)
            rowToBeEdited = -1
            isAddTapped = false
        }
        else if(isEdited){
            grpData[rowToBeEdited].groupName = textField.text!
            DBHelper.updateGrpName(existingGrpName: dataToBeEdited, newGrpName: textField.text!)
            isEdited = false
            rowToBeEdited = -1
            dataToBeEdited = ""
        }

        tableView.reloadData()
        textField.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        isAddTapped = false
        tableView.setEditing(false, animated: true)
        textField.resignFirstResponder()
        configureDataSource()
        return true
    }
}
