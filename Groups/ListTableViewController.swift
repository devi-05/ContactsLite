//
//  ListTableViewController.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 09/04/23.
//

import UIKit

//protocol groupsVcDelegate{
//    func addtoLocalGrpDataSource(grpName:[String],contact:Contacts)
//}

class ListTableViewController: UITableViewController,UITextFieldDelegate {
   
    var dataToBeEdited:String = ""

    var isAddTapped:Bool = false
    var isEdited:Bool = false
    var isEditButtonTapped = false
    var isEmptyString = false
    var temp = -1
    lazy var containerView:UIView = {
        let view = UIView()
        return view
    }()
//    lazy var editImage:UIImageView = {
//        let image = UIImage(named: "pencil")
//        let bannerWidth = navigationController?.navigationBar.frame.size.width
//              let bannerHeight = navigationController?.navigationBar.frame.size.height
//        let bannerX = bannerWidth! / 2 - (image?.size.width)! / 2
//              let bannerY = bannerHeight! / 2 - (image?.size.height)! / 2
//
//        let imgView = UIImageView(frame: CGRect(x: bannerX, y: bannerY, width: bannerWidth!, height: bannerHeight!))
//        imgView.image = image
//        imgView.tintColor = .systemBlue
//        imgView.contentMode = .scaleAspectFit
//        return imgView
//    }()
    lazy var grpData:[GroupModel] = []
    lazy var grpNames:[[String:Any]] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchGrpDataSource()
    }
    func fetchGrpDataSource(){
        lazy  var fetchedData = DBHelper.fetchData()
        lazy var dbContactList = Helper.decodeToContact(list: fetchedData)
         lazy var localDataSource = Helper.extractNamesFromFetchedData(lists: Helper.sort(data: dbContactList))
        grpNames = DBHelper.fetchGrpNames(colName: "GROUP_NAME")
       
        lazy var groupNames:[String] = Helper.getGrpNames(grpName: grpNames)
        grpData = Helper.getGroupsData(locDS: localDataSource, grpName: groupNames)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
       
        
        super.viewDidLoad()
   
        title = "Lists"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(edit))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),style: .plain, target: self, action: #selector(add))
        tableView.tableFooterView = nil
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(CustomListTableViewCell.self, forCellReuseIdentifier: CustomListTableViewCell.identifier)
        tableView.register(CustomListTableViewCell1.self, forCellReuseIdentifier: CustomListTableViewCell1.identifier)
        tableView.keyboardDismissMode = .onDrag
     
        
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isEmptyString){
            isEmptyString = false
            return grpData.count
        }
       else if(isAddTapped && !isEditButtonTapped){
           isAddTapped = false
            return  grpData.count+1
        }
        
        else{
            return  grpData.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            tableView.setEditing(false, animated: false)
        }
        else if(indexPath.row > grpData.count - 1){
            tableView.setEditing(false, animated: false)
        }
        else if(isEditButtonTapped) {
            tableView.setEditing(true, animated: true)
            isEditButtonTapped = false
        }
        if (temp == indexPath.row ){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomListTableViewCell.identifier) as? CustomListTableViewCell
            cell?.textField.placeholder = "List Name"
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
                    
                    
                    cell?.label2.text =  (indexPath.row == 0) ? (grpData[indexPath.row].data.count == 0 ? (String(grpData[indexPath.section].data.count)) : String(grpData[indexPath.section].data[indexPath.row].rows.count)):String(grpData[indexPath.row].data.count)
                }
            }

            return cell!
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if(indexPath.row != 0){
            let editAction = UIContextualAction(style: .normal,
                                                title: "Edit")
            { (action, view, completionHandler) in
                
                self.editFunctionalities(row: indexPath.row)
            }
            editAction.backgroundColor = .systemBlue.withAlphaComponent(0.6)
            let delAction = UIContextualAction(style: .normal,
                                               title: "Delete")
            {  (action, view, completionHandler) in
                
                self.deleteFunctionalities(row: indexPath.row)
            }
            delAction.backgroundColor = .systemRed.withAlphaComponent(0.8)
            return UISwipeActionsConfiguration(actions: [delAction,editAction])
        }
        else{
            return nil
        }
    }

    func editFunctionalities(row:Int){
        self.isEdited = true
        self.dataToBeEdited = self.grpData[row].groupName
        self.temp = row
        
        tableView.reloadData()
    }
    func deleteFunctionalities(row:Int){
        
        let alertController = UIAlertController(title: "", message: "Are you sure you want to delete the list ' \(self.grpData[row].groupName)'?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let delAction = UIAlertAction(title: "Delete",style:.destructive) { _ in
            
            DBHelper.deleteGroup(grpName: self.grpData[row ].groupName)
            self.grpData.remove(at: row)

            self.tableView.reloadData()
        }
            alertController.addAction(cancelAction)
            alertController.addAction(delAction)
            self.present(alertController, animated: true)
        
    }
    @objc func edit(){
        print("edit")

        view.endEditing(true)
        
    
        isEditButtonTapped = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        tableView.reloadData()
    }
    @objc func add(){
        print("add")
        isAddTapped = true
        temp = grpData.count
        tableView.reloadData()

        
    }
    @objc func done(){
        isAddTapped = true
        tableView.setEditing(false, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(add))
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0 && indexPath.row == 0){
            navigationController?.pushViewController(AllContactsVc(data: nil), animated: true)}
        else{
            let vc = AllContactsVc(data: grpData[indexPath.row])
            vc.isgroupPresent = true
            navigationController?.pushViewController(vc, animated: true)
        }

    }
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("end")
        let dateformat = DateFormatter()
        dateformat.dateFormat = "ddhhss"
        guard let myInt = Int(dateformat.string(from: Date()))  else {
          print("Conversion failed.")
            return
        }
        if(textField.text!.isEmpty){
            isEmptyString = true
            tableView.reloadData()
            return
        }
        if(isEdited){
            grpData[temp].groupName = textField.text!
            DBHelper.updateGrpName(existingGrpName: dataToBeEdited, newGrpName: textField.text!)
            isEdited = false
            temp = -1
            dataToBeEdited = ""
        }
        else{
            grpData.append(GroupModel(groupName: textField.text!, data: []))
            DBHelper.addGroup(grpName: textField.text!, grpId: myInt)
            temp = -1
            isAddTapped = false
        }
        tableView.reloadData()
        textField.resignFirstResponder()
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("resign")
        textField.resignFirstResponder()
        return true
    }
    

}
