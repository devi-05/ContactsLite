//
//  ProfilePageViewController.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 15/04/23.
//

import UIKit
import Foundation

struct Dict{
    var key:String
    var value:String
}
struct Datas{
    var sectionName:String
    var rows:[Dict]
}

class ProfilePageViewController: UITableViewController {
   
    
    var sectionData :[Datas]=[]
    var contact:Contact
    lazy var photoView:UIView = {
        let view = UIView(frame: CGRect(x: 10, y: 0, width: view.frame.size.width, height: 200))
        return view
    }()
    
    lazy var photoLabel:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .gray
        return imageView
    }()
    lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    lazy var workInfoLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 23, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    lazy var footerView : UIView  = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 50))
        view.isUserInteractionEnabled = true
        return view
    }()
   
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Edit", image: UIImage(systemName: "pencil"), handler: { (_) in
                
                let vc = InfoSheetViewController(contact: self.contact)
                vc.editDelegate = self
                self.navigationController?.pushViewController(vc, animated: true)
        
            }),
            UIAction(title: "Delete", image: UIImage(systemName: "trash"), handler: { (_) in
                
                let alertController = UIAlertController(title: nil, message: "Are you sure you want to delete this contact", preferredStyle: .alert)
                
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive){ _ in
                    
                    DBHelper.deleteContact(contactId: self.contact.contactId)
                    self.navigationController?.popViewController(animated: true)
                    
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .default){ _ in
                    
                    
                }
                alertController.addAction(cancelAction)
                alertController.addAction(deleteAction)
                
                
                self.present(alertController, animated: true)
                
                return
                
            })
        ]
    }
    
    var buttonMenu: UIMenu {
        return UIMenu(children: menuItems)
    }
    init(contact:Contact){
        self.contact = contact
        super.init(style: .insetGrouped)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        sectionData = []
        setUpContents()
        tableView.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .systemBackground

        view.addSubview(photoView)
        view.addSubview(footerView)
        photoView.addSubview(photoLabel)
        photoView.addSubview(nameLabel)
        photoView.addSubview(workInfoLabel)
        configureConstraints()
        setUpContents()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: nil)
        if #available(iOS 14.0, *) {
            navigationItem.rightBarButtonItem?.menu = buttonMenu
        } else {
            // Fallback on earlier versions
        }
        navigationController?.navigationBar.prefersLargeTitles = false
       configureTableView()
    }
    
    
    func configureConstraints(){
        photoLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        workInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoLabel.topAnchor.constraint(equalTo: photoView.topAnchor),
            photoLabel.centerXAnchor.constraint(equalTo: photoView.centerXAnchor),
            photoLabel.widthAnchor.constraint(equalToConstant: 120),
            photoLabel.heightAnchor.constraint(equalToConstant: 120),
            
            nameLabel.topAnchor.constraint(equalTo: photoLabel.bottomAnchor, constant: 5),
            nameLabel.centerXAnchor.constraint(equalTo: photoView.centerXAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: -20),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            workInfoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            workInfoLabel.centerXAnchor.constraint(equalTo: photoView.centerXAnchor),
            workInfoLabel.trailingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: -20),
            workInfoLabel.heightAnchor.constraint(equalToConstant: 50),
            
        ])
        
    }
    func configureTableView(){
        tableView.backgroundColor = .systemBackground
        tableView.tableHeaderView = photoView
        tableView.contentInset = .init(top: 0, left: 0, bottom: 70, right: 0)
        tableView.register(ProfPageTableViewCell.self, forCellReuseIdentifier: ProfPageTableViewCell.identifier)
        tableView.register(EmailTableViewCell.self, forCellReuseIdentifier: EmailTableViewCell.identifier)
        tableView.register(AddressDisplayTableViewCell.self, forCellReuseIdentifier: AddressDisplayTableViewCell.identifier)
        tableView.register(NotesDisplayTableViewCell.self, forCellReuseIdentifier: NotesDisplayTableViewCell.identifier)
    }
    func setUpContents(){
        if let lastName = contact.lastName
        {
            nameLabel.text = "\(contact.firstName)  \(lastName)"}
        else{
            nameLabel.text = contact.firstName
            
        }
        
        if let image = contact.profileImage {
            photoLabel.image = UIImage(data:image)
            photoLabel.tintColor = .gray
            photoLabel.layer.cornerRadius = 60
            photoLabel.clipsToBounds = true


        }
        else{
            photoLabel.image = UIImage(systemName: "person.circle.fill")
            photoLabel.tintColor = .gray
        }
        
        if let workInfo = contact.workInfo{
            
            workInfoLabel.text = workInfo
        }
        else{
            workInfoLabel.text = nil
        }
        setImage()
        setPhoneNumber()
        setEmail()
        setAddress()
        setSocialprofile()
        setNotes()
    }
    func setImage(){
        if let imageData = contact.profileImage{
            photoLabel.image = UIImage(data: imageData)
            photoLabel.tintColor = .gray
        }
    }
    
    func setPhoneNumber(){
        var temp:[Dict] = []
        print("phn num : \(contact.phoneNumber)")
        for i in contact.phoneNumber{
            if let number = i.number{
                print(i)
                temp.append(Dict(key: i.modelType, value: String(number)))
            }
        }
        print("temp \(temp)")
        sectionData.append(Datas(sectionName: "Phone Number", rows: temp))
    }
    func setEmail(){
        var temp:[Dict] = []
        if(contact.email?.count != 0){
            if let email = contact.email{
                for i in email{
                    if (!i.isEmpty){
                        temp.append(Dict(key: "", value: i))
                    }
                }
                
                sectionData.append(Datas(sectionName: "Email", rows: temp))
            }
        }
    }
    func setAddress(){
        var temp:[Dict] = []
       
        if(contact.address?.count != 0){
            if let contactAddress = contact.address{
                for i in contactAddress{
                    var address:String = ""
                    if (i.doorNo) != nil{
                        address+="\(i.doorNo!)\n"
                    }
                    if (i.Street) != nil{
                        address+="\(i.Street!)\n"
                    }
                    if (i.city) != nil{
                        address+="\(i.city!)\n"
                    }
                    if (i.postcode) != nil{
                        address+="\(i.postcode!)\n"
                    }
                    if (i.state) != nil{
                        address+="\(i.state!)\n"
                    }
                    if (i.country) != nil{
                        address+="\(i.country!)"
                    }
                    
                    temp.append(Dict(key: i.modelType, value: address))
                }
            }
            sectionData.append(Datas(sectionName: "Address", rows: temp))
        }
    }
    func setSocialprofile(){
        var temp:[Dict] = []
        if(contact.socialProfile?.count != 0){
            if let socialProfile = contact.socialProfile{
                for i in socialProfile{
                    if i.link != nil{
                        temp.append(Dict(key: i.profileType, value: i.link!))
                    }
                }
            }
            sectionData.append(Datas(sectionName: "Social Profile", rows: temp))
        }
    }
    
    func setNotes(){
        var temp:[Dict] = []
        if let notes = contact.notes{
            if (!notes.isEmpty) {
                temp.append(Dict(key: "", value: contact.notes!))
                sectionData.append(Datas(sectionName: "Notes", rows: temp))
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionData[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(sectionData[section].sectionName == Headers.phoneNumber){
            return 30
        }
        else{
            return 3
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
         if sectionData[indexPath.section].sectionName == Headers.address{
            return 170
        }
        else if sectionData[indexPath.section].sectionName == Headers.notes{
            return UITableView.automaticDimension
//            if let notes = contact.notes {
//                let font = UIFont.systemFont(ofSize: 17)
//                let size = (notes as NSString).size(withAttributes: [.font: font])
//                print(size.height)
//                return size.height
//            }
//            else{
//                return 0
//            }
        }
        else{
            
            return 70
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if sectionData[indexPath.section].sectionName == "Email" {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmailTableViewCell.identifier) as! EmailTableViewCell
            cell.header.text = sectionData[indexPath.section].rows[indexPath.row].value
            
            return cell
        }
        else if sectionData[indexPath.section].sectionName == "Notes"{
            let cell = tableView.dequeueReusableCell(withIdentifier: NotesDisplayTableViewCell.identifier) as! NotesDisplayTableViewCell
            cell.subHeaders.text = sectionData[indexPath.section].rows[indexPath.row].value
            return cell
        
            
        }
        else if  sectionData[indexPath.section].sectionName == Headers.address {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddressDisplayTableViewCell.identifier) as! AddressDisplayTableViewCell
            print(sectionData)
            cell.header.text = sectionData[indexPath.section].rows[indexPath.row].key
            cell.subHeader.text = sectionData[indexPath.section].rows[indexPath.row].value
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfPageTableViewCell.identifier) as! ProfPageTableViewCell
            print(sectionData)
            cell.header.text = sectionData[indexPath.section].rows[indexPath.row].key
            cell.subHeader.text = sectionData[indexPath.section].rows[indexPath.row].value
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(indexPath.section == 0){
            let alertController = UIAlertController(title: nil, message: "Are You sure you want to make a call", preferredStyle: .alert)
            
            let callAction = UIAlertAction(title: "Call", style: .default){ _ in
                Helper.makeACall(number: self.sectionData[indexPath.section].rows[indexPath.row].value)
                //                        self.dismiss(animated: true)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive){ _ in
                
                
            }
            
            
            alertController.addAction(cancelAction)
            alertController.addAction(callAction)
            
            present(alertController, animated: true)
            
            return
            
            
        }
    }
}
extension ProfilePageViewController:EditDelegate{
    func getUpdatedContact(newContact: Contact) {
        self.contact = newContact
        tableView.reloadData()
    }
}
