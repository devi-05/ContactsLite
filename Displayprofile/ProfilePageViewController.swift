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
class ProfilePageViewController: UITableViewController,editDelegate {
    func getUpdatedContact(newContact: Contacts) {
        self.contact = newContact
        tableView.reloadData()
    }
  
    var sectionData :[Datas]=[]
    var contact:Contacts
    init(contact:Contacts){
        self.contact = contact
        super.init(style: .insetGrouped)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        let view = UIView()
        return view
    }()
    lazy var deleteButton:UIButton = {
        let button = UIButton(frame: CGRect(x: 150, y: 0, width: 80, height: 50))
        button.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 5 // 38, 33, 35
        button.layer.borderColor = .init(red: 38/255, green: 33/255, blue: 35/255, alpha: 1)
      
        button.backgroundColor = .systemRed
        button.addTarget(self, action: #selector(del), for: .touchUpInside)
        return button
    }()
    override func viewWillAppear(_ animated: Bool) {

        sectionData = []
        setUpContents()
        tableView.reloadData()
       

    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionData[section].rows.count
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(photoView)
        view.addSubview(deleteButton)
        photoView.addSubview(photoLabel)
        photoView.addSubview(nameLabel)
        photoView.addSubview(workInfoLabel)
        configureConstraints()
        setUpContents()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(edit))
        navigationController?.navigationBar.prefersLargeTitles = false
        tableView.tableHeaderView = photoView
        footerView.addSubview(deleteButton)
        tableView.tableFooterView = footerView
        tableView.backgroundColor = .systemBackground.withAlphaComponent(0.9)
        tableView.register(ProfPageTableViewCell.self, forCellReuseIdentifier: ProfPageTableViewCell.identifier)
        tableView.register(EmailAndNotesTableViewCell.self, forCellReuseIdentifier: EmailAndNotesTableViewCell.identifier)
        tableView.register(AddressDisplayTableViewCell.self, forCellReuseIdentifier: AddressDisplayTableViewCell.identifier)
    
    }
    
    
    @objc func edit(){
        print(contact)
        let vc = InfoSheetViewController(contact: contact)
        vc.editDelegate = self
        navigationController?.pushViewController(vc, animated: true)
   
    }
    @objc func del(){
        DBHelper.deleteContact(contactId: contact.contactId)
        navigationController?.popViewController(animated: true)
        
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
    func setUpContents(){
        if let lastName = contact.lastName
        {
            nameLabel.text = "\(contact.firstName)  \(lastName)"}
        else{
            nameLabel.text = contact.firstName
            
        }
        
        if let image = contact.profileImage {
            photoLabel.image = UIImage(data:image)
            photoLabel.layer.cornerRadius = 60
            photoLabel.clipsToBounds = true
            
            
        }
        else{
            photoLabel.image = UIImage(systemName: "person.circle.fill")
            
        }
       
        if let workInfo = contact.workInfo{
            
            workInfoLabel.text = workInfo
        }
        else{
            workInfoLabel.text = nil
        }
        setPhoneNumber()
        setEmail()
        setAddress()
        setSocialprofile()
        setNotes()
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
        var address:String = ""
        if(contact.address?.count != 0){
            if let contactAddress = contact.address{
                for i in contactAddress{
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
        if(contact.email?.count != 0){
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
   
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(sectionData[section].sectionName == Headers.phoneNumber){
            return 30
        }
        else{
            return 3
        }
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width-10, height: 50))
//        header.layer.cornerRadius = 20
//        header.tag = section
//        let mylabel = UILabel(frame: CGRect(x: 0, y: 0, width: header.frame.size.width-10, height: 50))
//        mylabel.text = sectionData[section].sectionName
//        mylabel.textColor = .label.withAlphaComponent(0.5)
//        mylabel.textAlignment = .center
//        mylabel.font = .systemFont(ofSize: 20, weight: .medium)
//        let myImage = UIImageView(frame:CGRect(x: 70, y: 12, width: 25, height: 25))
//        switch sectionData[section].sectionName {
//            
//        case "Phone Number":
//            myImage.image =  UIImage(systemName: "phone.down.circle")
//        case "Email":
//            myImage.image = UIImage(systemName: "envelope.fill")
//        case "Address":
//            myImage.image = UIImage(systemName: "house.fill")
//        case "Social Profile":
//            myImage.image =  UIImage(systemName: "person.crop.circle.dashed")
//        default:
//            myImage.image = UIImage(systemName: "doc.text")
//        }
//        myImage.tintColor = .label.withAlphaComponent(0.4)
//        header.addSubview(mylabel)
//        header.addSubview(myImage)
//        return header
//    }
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch sectionData[section].sectionName{
//        case Headers.phoneNumber:
//            return Headers.phoneNumber
//        case Headers.email:
//            return Headers.email
//        case Headers.address:
//            return Headers.address
//        case Headers.socialProfile:
//            return Headers.socialProfile
//        case Headers.notes:
//            return Headers.notes
//        default:
//            return " "
//        }
//
//    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sectionData[indexPath.section].sectionName == Headers.email || sectionData[indexPath.section].sectionName == Headers.notes{
            return 40}
        else if sectionData[indexPath.section].sectionName == Headers.address{
            return 120
        }
        else{
            
            return 70
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if sectionData[indexPath.section].sectionName == "Email" || sectionData[indexPath.section].sectionName == "Notes"{
            let cell = tableView.dequeueReusableCell(withIdentifier: EmailAndNotesTableViewCell.identifier) as! EmailAndNotesTableViewCell
            cell.header.text = sectionData[indexPath.section].rows[indexPath.row].value
            
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
    }
  
}