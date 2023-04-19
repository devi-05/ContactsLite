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
    var contact:Contacts
    init(contact:Contacts){
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
        
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
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(edit))
        navigationController?.navigationBar.prefersLargeTitles = false
        photoView.addSubview(photoLabel)
        photoView.addSubview(nameLabel)
        photoView.addSubview(workInfoLabel)
        view.addSubview(photoView)
        configureConstraints()
        print(contact)
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
        setPhoneNumber()
        setEmail()
        setAddress()
        setSocialprofile()
        setNotes()
        print(sectionData)
        tableView.tableHeaderView = photoView
        
        tableView.register(ProfPageTableViewCell.self, forCellReuseIdentifier: ProfPageTableViewCell.identifier)
        tableView.register(EmailAndNotesTableViewCell.self, forCellReuseIdentifier: EmailAndNotesTableViewCell.identifier)
        
    }
    

    @objc func edit(){
        navigationController?.pushViewController(InfoSheetViewController(contact: contact), animated: true)
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
            workInfoLabel.heightAnchor.constraint(equalToConstant: 50)
            
            
        ])
    }
    func setPhoneNumber(){
        var temp:[Dict] = []
        for i in contact.phoneNumber{
            
            temp.append(Dict(key: i.modelType, value: String(i.number!)))
        }
        sectionData.append(Datas(sectionName: "Phone Number", rows: temp))
    }
    func setEmail(){
        var temp:[Dict] = []
        
              for i in contact.Email!{
                  if (!i.isEmpty){
                  temp.append(Dict(key: "", value: i))
              }
          }
        sectionData.append(Datas(sectionName: "Email", rows: temp))
    }
    func setAddress(){
        var temp:[Dict] = []
        var address:String = ""
        for i in contact.address!{
            if (i.doorNo) != nil{
                address+=String(describing: i.doorNo!)
            }
            if (i.Street) != nil{
                address+=String(describing: i.Street!)
            }
            if (i.city) != nil{
                address+=String(describing: i.city!)
            }
            if (i.postcode) != nil{
                address+=String(describing: i.postcode!)
            }
            if (i.state) != nil{
                address+=String(describing: i.state!)
            }
            if (i.country) != nil{
                address+=String(describing: i.country!)
            }
            
            temp.append(Dict(key: i.modelType, value: address))
            
        }
        sectionData.append(Datas(sectionName: "Address", rows: temp))
    }
    func setSocialprofile(){
        var temp:[Dict] = []
        for i in contact.socialprofile!{
            if i.link != nil{
                temp.append(Dict(key: i.profileType, value: i.link!))
            }
        }
        sectionData.append(Datas(sectionName: "Social Profile", rows: temp))
    }
    func setNotes(){
        var temp:[Dict] = []
        if (!contact.notes!.isEmpty) {
            temp.append(Dict(key: "", value: contact.notes!))
            sectionData.append(Datas(sectionName: "Notes", rows: temp))
        }
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionData[section].rows.count
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width-10, height: 50))
        header.layer.cornerRadius = 20
        header.tag = section
        let mylabel = UILabel(frame: CGRect(x: 0, y: 0, width: header.frame.size.width-10, height: 50))
        mylabel.text = sectionData[section].sectionName
        mylabel.textColor = .label.withAlphaComponent(0.5)
        mylabel.textAlignment = .center
        mylabel.font = .systemFont(ofSize: 20, weight: .medium)
        let myImage = UIImageView(frame:CGRect(x: 70, y: 12, width: 25, height: 25))
        switch sectionData[section].sectionName {
            
        case "Phone Number":
            myImage.image =  UIImage(systemName: "phone.down.circle")
        case "Email":
            myImage.image = UIImage(systemName: "envelope.fill")
        case "Address":
            myImage.image = UIImage(systemName: "house.fill")
        case "Social Profile":
            myImage.image =  UIImage(systemName: "person.crop.circle.dashed")
        default:
            myImage.image = UIImage(systemName: "doc.text")
        }
        myImage.tintColor = .label.withAlphaComponent(0.4)
        header.addSubview(mylabel)
        header.addSubview(myImage)
        return header
    }
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionData[section].sectionName
//    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sectionData[indexPath.section].sectionName == "Email" || sectionData[indexPath.section].sectionName == "Notes"{
            return 40
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
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfPageTableViewCell.identifier) as! ProfPageTableViewCell
            
            cell.header.text = sectionData[indexPath.section].rows[indexPath.row].key
            cell.subHeader.text = sectionData[indexPath.section].rows[indexPath.row].value
            return cell
        }
    }

}
