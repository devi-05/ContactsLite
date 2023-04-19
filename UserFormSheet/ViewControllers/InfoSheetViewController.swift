//  InfoSheetViewController.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 31/03/23.
//

import UIKit


protocol Delegate{
    func getOptions(option:String,type:String)
}

protocol ImageDelegate{
    func getImage(images:UIImage)
}





class InfoSheetViewController: UITableViewController, UINavigationControllerDelegate,Delegate, UITextViewDelegate,ImageDelegate, UIImagePickerControllerDelegate {
    
    weak var tabvc:TabBarViewController?
    weak var allContactsVc:AllContactsVc?
    var info:Contacts?
    
    init(contact:Contacts?){
        super.init(nibName: nil, bundle: nil)
        self.info = contact
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    var id:Int?
    var image:UIImage?
    var firstName:String = ""
    var lastName:String?
    var workInfo:String?
    var emailArray:[String] = []
    var isFavourite:Int = 0
    var isEmergencyContact:Int = 0
    var notes:String?
    var groups:[String] = []
    
    var doorNo:Int?
    var street:String?
    var city:String?
    var postcode:Int?
    var state:String?
    var country:String?
    
    
    var link:String?
    var socialProfOption:String?
    
    var addressOption:String?
    
    var phoneNumRowIndex:Int?
    
    var addressRowIndex:Int?
    
    var socialProfileRowIndex:Int?
    
    var phoneNumModel:[PhoneNumberModel] = []
    
    var addressModel:[AddressModel] = []
    
    var socialProfileModel:[SocialProfileModel] = []
    
    var contactsList:[Contacts] = []
    
    var contact:Contacts?
    
    
    
    
    var preferredPhoneNumOption:String="mobile"
    
    var preferredAddressOption:String="home"
    
    var preferredSocialProfileOption:String="Twitter"
    
    
    
    var headerDataSource:[DataSource] = [
        DataSource(data: [Headers.firstName,"Last Name"]),
        DataSource(data: ["Work Info"]),
        DataSource(data: ["PhoneNumber"]),
        DataSource(data: ["Email"]),
        DataSource(data: ["Address"]),
        DataSource(data: ["Social Profile"]),
        DataSource(data: ["Favourites"]),
        DataSource(data: ["Emergency Contact"]),
        DataSource(data: ["Notes"]),
        DataSource(data: ["Groups"])]
    
    
    lazy var photoLabel:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .gray
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var addPhotoButton:UIButton = {
        let button = UIButton()
        button.setTitle("Add Photo", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    lazy var photoView:UIView = {
        let view = UIView(frame: CGRect(x: 10, y: 0, width: view.frame.size.width, height: 200))
        return view
    }()
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Camera", image: UIImage(systemName: "camera.circle.fill"), handler: { (_) in
                let vc = UIImagePickerController()
                vc.sourceType = .camera
                vc.delegate = self
                vc.allowsEditing = true
                self.present(vc, animated: true)
            }),
            UIAction(title: "Photos", image: UIImage(systemName: "photo.on.rectangle.angled"), handler: { (_) in
                let vc = UIImagePickerController()
                vc.sourceType = .photoLibrary
                vc.delegate = self
                vc.allowsEditing = true
                self.present(vc, animated: true)
            })
        ]
    }
    
    var buttonMenu: UIMenu {
        return UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    func getImage(images: UIImage) {
        image = images
        photoLabel.image = image
        photoLabel.layer.cornerRadius = photoLabel.frame.size.width / 2
        photoLabel.layer.masksToBounds = true
        
    }
    func getOptions(option: String,type: String) {
        if type == "phoneNumber" {
            
            phoneNumModel[phoneNumRowIndex! - 1].modelType = option
            
            
        }
        else if type == "address"{
            
            addressOption = option
            
        }
        
        else if type == "Social Profile"{
            
            socialProfOption = option
        }
        tableView.reloadData()
        
        
    }
    lazy var grpData:[GroupModel] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lazy  var fetchedData = DBHelper.fetchData()
        lazy var dbContactList = Helper.decodeToContact(list: fetchedData)
        lazy var localDataSource = Helper.extractNamesFromFetchedData(lists: Helper.sort(data: dbContactList))
        lazy var grpNames = DBHelper.fetchGrpNames(colName: "GROUP_NAME")
        lazy var groupNames:[String] = Helper.getGrpNames(grpName: grpNames)
        
        grpData = Helper.getGroupsData(locDS:localDataSource , grpName: groupNames)
        print("grpdata\(grpData)")
        

        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Contact"
        print(grpData)
        view.backgroundColor = .secondarySystemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(cancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(DoneButton))
        
        addSubviewsToPhotoView()
        tableView.allowsSelection = true
        setUpTableView()
        tableView.keyboardDismissMode = .onDrag
        if #available(iOS 14.0, *) {
            addPhotoButton.menu = buttonMenu
            addPhotoButton.showsMenuAsPrimaryAction = true
        } else {
            // Fallback on earlier versions
        }
        guard (info == nil) else{
            id = info?.contactId
            if(info?.profileImage != nil){
                image = UIImage(data: (info?.profileImage)!)
                photoLabel.image = image
                photoLabel.layer.cornerRadius = photoLabel.frame.size.width / 2
                photoLabel.layer.masksToBounds = true
                
            }
            
            firstName = info!.firstName
            lastName = info?.lastName
            workInfo = info?.workInfo
            phoneNumModel = info!.phoneNumber
            emailArray = (info?.Email)!
            addressModel = (info?.address)!
            socialProfileModel = (info?.socialprofile)!
            notes = info?.notes
            isFavourite = (info?.favourite)!
            isEmergencyContact = (info?.emergencyContact)!
            
            return
        }
    }
    
    @objc func cancelButton(){
        dismiss(animated: true)
    }
    
    @objc func DoneButton(){
        dismiss(animated: true)
        guard !firstName.isEmpty,
              !phoneNumModel.isEmpty else {
            return
        }
        let dateformat = DateFormatter()
        dateformat.dateFormat = "ddmmss"
        guard let myInt = Int(dateformat.string(from: Date()))  else {
            print("Conversion failed.")
            return
        }
        id = myInt
        let newContact = Contacts(contactId: id!,profileImage: image?.pngData(), firstName: firstName,lastName: lastName,workInfo: workInfo,phoneNumber: phoneNumModel,Email: emailArray,address: addressModel,socialprofile: socialProfileModel,favourite:isFavourite,emergencyContact: isEmergencyContact,notes: notes,groups: groups)
        
        DBHelper.assignDb(contactList: newContact)
//        tabvc?.refreshFavData()
        allContactsVc?.refreshDataSource()
        allContactsVc?.tableView.reloadData()

        addtoLocalGrpDataSource(grpName:groups,contact:newContact)

        
        
    }
    
    func addSubviewsToPhotoView() {
        photoView.addSubview(photoLabel)
        photoView.addSubview(addPhotoButton)
    }
    func configureConstraints(){
        
        photoLabel.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoLabel.centerXAnchor.constraint(equalTo: photoView.centerXAnchor),
            photoLabel.topAnchor.constraint(equalTo: photoView.topAnchor),
            photoLabel.widthAnchor.constraint(equalToConstant: 150),
            photoLabel.heightAnchor.constraint(equalToConstant: 150),
            
            addPhotoButton.topAnchor.constraint(equalTo: photoLabel.bottomAnchor),
            addPhotoButton.leadingAnchor.constraint(equalTo: photoLabel.leadingAnchor),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 150),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 40)])
        
        
    }
    
    @objc func addPhoto() {
        let imgPicker = ImagePickerViewController()
        imgPicker.delegate = self
        present(UINavigationController(rootViewController: imgPicker), animated: true)
        print("adding photo")
    }
    func setUpTableView(){
        tableView.allowsSelectionDuringEditing = true
        tableView.isEditing = true
        tableView.backgroundColor = .systemBackground
        tableView.frame = view.bounds
        tableView.tableHeaderView = photoView
        configureConstraints()
        tableView.register(ContactNameTableViewCell.self, forCellReuseIdentifier: ContactNameTableViewCell.identifier )
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: InfoTableViewCell.identifier)
        tableView.register(AddTableViewCell.self, forCellReuseIdentifier: AddTableViewCell.identifier)
        tableView.register(SocialProfileTableViewCell.self, forCellReuseIdentifier: SocialProfileTableViewCell.identifier)
        tableView.register(PhoneNumberTableViewCell.self, forCellReuseIdentifier: PhoneNumberTableViewCell.identifier)
        tableView.register(AddressTableViewCell.self, forCellReuseIdentifier: AddressTableViewCell.identifier)
        tableView.register(NotesTableViewCell.self, forCellReuseIdentifier: NotesTableViewCell.identifier)
        tableView.register(FavouriteAndEmergencyContactTableViewCell.self, forCellReuseIdentifier: FavouriteAndEmergencyContactTableViewCell.identifier)
        tableView.register(GroupsTableViewCell.self, forCellReuseIdentifier: GroupsTableViewCell.identifier)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return headerDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return section == 0 ? 2: ( section == (headerDataSource.count - 1) ? grpData.count:headerDataSource[section].data.count)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 8 || indexPath.section == 6 || indexPath.section == 7 || (indexPath.section == 9 && indexPath.row == 0){
            return UITableViewCell.EditingStyle.none
        }
        
        
        if indexPath.section > 0 && indexPath.row > 0 && indexPath.section != 9 {
            return UITableViewCell.EditingStyle.delete
        }
        
        if indexPath.section > 0 || (indexPath.section == 9 && indexPath.row > 0){
            return  UITableViewCell.EditingStyle.insert
        }
        
        else{
            return UITableViewCell.EditingStyle.none
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .insert{
            if(indexPath.section != 9){
                if (indexPath.section == 2){
                    phoneNumModel.append(PhoneNumberModel(modelType: "mobile"))
                }
                else if (indexPath.section == 4){
                    addressOption = "home"
                    //                    addressModel.append(AddressModel(modelType: "home"))
                }
                else if (indexPath.section == 5) {
                    socialProfOption = "Twitter"
                    //                    socialProfileModel.append(SocialProfileModel(profileType: "Twitter"))
                }
                headerDataSource[indexPath.section].data.append(headerDataSource[indexPath.section].data[0])
                tableView.insertRows(at: [IndexPath(row:  headerDataSource[indexPath.section].data.count-1, section: indexPath.section)], with: .bottom)
            }
            else{
                groups.append(grpData[indexPath.row].groupName)
                
            }
        }
        else if editingStyle == .delete {
            if (indexPath.section == 2){
                phoneNumModel.remove(at: indexPath.row - 1)
            }
            else if (indexPath.section == 4){
                if (!addressModel.isEmpty){
                    addressModel.remove(at: indexPath.row - 1)
                }
            }
            
            headerDataSource[indexPath.section].data.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .left)
            tableView.reloadData()
        }
    
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  indexPath.section != 0 else{
            let cell = tableView.dequeueReusableCell(withIdentifier: ContactNameTableViewCell.identifier, for: indexPath) as? ContactNameTableViewCell
            if firstName != "" && indexPath.row == 0 {
                cell?.textField.text = firstName
            }
            if lastName != nil && indexPath.row == 1 {
                cell?.textField.text = lastName
            }
            cell?.textField.attributedPlaceholder = NSAttributedString(string:(headerDataSource[indexPath.section].data[indexPath.row]) ,attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
            cell?.textField.delegate = self
            return cell!
        }
        
        if(indexPath.section == 2 && indexPath.row > 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: PhoneNumberTableViewCell.identifier, for: indexPath) as? PhoneNumberTableViewCell
            
            cell?.optionLabel.text = phoneNumModel[indexPath.row-1].modelType
            cell?.numInput.attributedPlaceholder = NSAttributedString(string:"phone",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.5)])
            cell?.cellView.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
            cell?.cellView.tag = indexPath.row
            cell?.numInput.delegate = self
            cell?.numInput.tag = indexPath.row
            
            if let number = phoneNumModel[indexPath.row-1].number {
                
                cell?.numInput.text = String(number)
            }
            
            return cell!
        }
        
        if(indexPath.section == 4 && indexPath.row > 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: AddressTableViewCell.identifier, for: indexPath) as? AddressTableViewCell
            if(indexPath.row - 1 < addressModel.count){
                cell?.doorNumTf.text = String( addressModel[indexPath.row - 1].doorNo ?? 0)
                cell?.streetTf.text = String( addressModel[indexPath.row - 1].Street ?? "" )
                cell?.cityTf.text = String( addressModel[indexPath.row - 1].city ?? "")
                cell?.postCodeTf.text = String( addressModel[indexPath.row - 1].postcode ?? 0)
                cell?.stateTf.text = String(addressModel[indexPath.row - 1].state ?? "")
                cell?.CountryTf.text = String( addressModel[indexPath.row - 1].country ?? "")
                
            }
            
            cell?.optionLabel.text = addressOption
            cell?.optionButton.addTarget(self, action: #selector(addressOptions), for: .touchUpInside)
            
            cell?.doorNumTf.delegate = self
            cell?.streetTf.delegate = self
            cell?.cityTf.delegate = self
            cell?.postCodeTf.delegate = self
            cell?.stateTf.delegate = self
            cell?.CountryTf.delegate = self
            
            cell?.optionButton.tag = indexPath.row
            cell?.doorNumTf.tag = indexPath.row
            cell?.streetTf.tag = indexPath.row
            cell?.cityTf.tag = indexPath.row
            cell?.postCodeTf.tag = indexPath.row
            cell?.stateTf.tag = indexPath.row
            cell?.CountryTf.tag = indexPath.row
            
            return cell!
        }
        
        if (indexPath.section == 5 && indexPath.row > 0){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SocialProfileTableViewCell.identifier, for: indexPath) as? SocialProfileTableViewCell
            if(indexPath.row-1 < socialProfileModel.count){
                cell?.numInput.text = String( socialProfileModel[indexPath.row - 1].link!)
            }
            cell?.optionLabel.text = socialProfOption
            cell?.numInput.attributedPlaceholder = NSAttributedString(string:"Social Profile",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.5)])
            cell?.cellView.tag = indexPath.row
            cell?.numInput.keyboardType = .emailAddress
            cell?.numInput.delegate = self
            cell?.numInput.tag = indexPath.row
            
            cell?.cellView.addTarget(self, action: #selector(socialProfileOptions), for: .touchUpInside)
            return cell!
        }
        
        if (indexPath.section == 8){
            let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.identifier) as! NotesTableViewCell
            cell.textView.delegate = self
            return cell
        }
        if (indexPath.section == 6){
            let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteAndEmergencyContactTableViewCell.identifier) as! FavouriteAndEmergencyContactTableViewCell
            cell.text.text = "Favourite"
            cell.images.addTarget(self, action: #selector(tapFavourite), for: .touchUpInside)
            
            if (isFavourite == 0){
                cell.images.setImage(UIImage(systemName: "star"), for: .normal)
                cell.images.tintColor = .systemBlue
            }
            return cell
        }
        if (indexPath.section == 7){
            let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteAndEmergencyContactTableViewCell.identifier) as! FavouriteAndEmergencyContactTableViewCell
            cell.text.text = "Emergency Contact"
            cell.images.addTarget(self, action: #selector(tapEmergency), for: .touchUpInside)
            if(isEmergencyContact == 0){
                cell.images.setImage(UIImage(systemName: "staroflife"), for: .normal)
                cell.images.tintColor = .systemRed
                
            }
            
            return cell
        }
        if (indexPath.section == 9 && indexPath.row > 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: GroupsTableViewCell.identifier) as! GroupsTableViewCell
            cell.selectionStyle = .blue
            cell.label.text = grpData[indexPath.row].groupName
            cell.label.textColor = .label
            return cell
        }
        
        if(indexPath.row == 0){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as! InfoTableViewCell
            cell.textLabels.text = headerDataSource[indexPath.section].data[indexPath.row]
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: AddTableViewCell.identifier, for: indexPath) as! AddTableViewCell
            if(indexPath.section == 1){
                
                cell.textField.text = workInfo
            }
            if(indexPath.section == 3){
                if indexPath.row-1 < emailArray.count {
                    print( "email id is \(emailArray[indexPath.row-1])")
                    cell.textField.text = emailArray[indexPath.row-1]
                }
            }
            cell.textField.attributedPlaceholder = NSAttributedString(string: (headerDataSource[indexPath.section].data[indexPath.row]),attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.5)])
            cell.textField.delegate = self
            
            return cell
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0:30
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ( indexPath.section == 4 && indexPath.row > 0){
            return 300.0
        }
        else if indexPath.section == 8{
            return 150.0
        }
        else{
            return 60.0
        }
    }
    @objc func addressOptions(sender:UIButton){
        print("in address options")
        addressRowIndex = sender.tag
        //        print(sender.tag)
        let addressVc = AddressTableViewController()
        addressVc.delegate = self
        present(UINavigationController(rootViewController: addressVc), animated: true)
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.section == 9 && indexPath.row > 0){
            //            print("in 9")
            groups.append(grpData[indexPath.row].groupName)
            //            print("====> \(groups)")
        }
        
    }
    
    @objc func showOptions(sender:UIButton){
        phoneNumRowIndex = sender.tag
        let phone = PhoneNumOptionsTableView()
        phone.delegate = self
        present(UINavigationController(rootViewController: phone), animated: true)
    }
    @objc func socialProfileOptions(sender:UIButton){
        socialProfileRowIndex = sender.tag
        let vc = SocialProfileTableViewController()
        vc.delegate = self
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    @objc func tapFavourite(sender:UIButton){
        if (isFavourite == 0){
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
            isFavourite = 1
        }
        else{
            sender.setImage(UIImage(systemName: "star"), for: .normal)
            isFavourite = 0
        }
        sender.tintColor = .systemBlue
        
        
    }
    @objc func tapEmergency(sender:UIButton){
        
        if (isEmergencyContact == 0){
            sender.setImage(UIImage(systemName: "staroflife.fill"), for: .normal)
            isEmergencyContact = 1
        }
        else{
            sender.setImage(UIImage(systemName: "staroflife"), for: .normal)
            isEmergencyContact = 0
        }
        sender.tintColor = .systemRed
        
        
    }
    
}

extension InfoSheetViewController:UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //        print(textField.attributedPlaceholder?.string as Any)
        //        print(textField.text!)
        
        
        switch textField.attributedPlaceholder?.string{
        case "First Name":
            firstName = textField.text!
        case "Last Name":
            lastName = textField.text!
        case "Work Info":
            workInfo = textField.text!
        case "Email":
            emailArray.append(textField.text!)
            //            print("in did end email \(emailArray)")
        case "phone":
            phoneNumModel[textField.tag - 1 ].number = Int64(textField.text!)
        case "Door no." :
            doorNo = Int(textField.text!)
            
        case "street":
            street = textField.text!
            
            //            addressModel[textField.tag - 1].Street = textField.text!
        case "City":
            city = textField.text!
            //            addressModel[textField.tag - 1].city = textField.text!
        case "PostCode":
            postcode = Int(textField.text!)
            //            addressModel[textField.tag - 1].postcode = Int(textField.text!)
        case "state":
            state = textField.text!
            //            addressModel[textField.tag - 1].state = textField.text!
        case "Country":
            country = textField.text!
            addressModel.append(AddressModel(modelType: addressOption!,doorNo: doorNo,Street: street,city: city,postcode: postcode,state: state,country: country))
            
        case "Social Profile":
            link = textField.text!
            socialProfileModel.append(SocialProfileModel(profileType: socialProfOption!,link: link))
            
            //            socialProfileModel[textField.tag - 1].link = textField.text!
        default:
            return
        }
        
        
        //        print("phn ==>  \(phoneNumModel)")
        //        print("add ==> \(addressModel)")
        //        print("sp ==> \(socialProfileModel)")
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray {
            textView.text = ""
            textView.textColor = UIColor.label
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        notes = textView.text!
        //        print(textView.text!)
        if textView.text == "" {
            textView.text = "Notes"
            textView.textColor = UIColor.gray
        }
        textView.resignFirstResponder()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //        print(info)
        if let images = info[.editedImage] as? UIImage{
            photoLabel.image = images
            photoLabel.layer.cornerRadius = 75
            photoLabel.layer.masksToBounds = true
            image = images
        }
        
        picker.dismiss(animated: true)
        addPhotoButton.setTitle("Edit Photo", for: .normal)
    }
    func addtoLocalGrpDataSource(grpName:[String],contact:Contacts){
        for i in grpName{
            if grpData.isEmpty {
                grpData.append(GroupModel(groupName: i, data: [SectionContent(sectionName: String(contact.firstName.first!), rows: [contact])]))
                
            }
            else{
                var bool = false
                for j in 0..<grpData.count{
                    if (grpData[j].groupName == i){
                        for k in 0..<grpData[j].data.count{
                            if(grpData[j].data[k].sectionName == String(contact.firstName.first!)){
                                grpData[j].data[k].rows.append(contact)
                                bool = true
                            }
                        }
                        if (!bool){
                            
                            grpData.append(GroupModel(groupName: i, data: [SectionContent(sectionName: String(contact.firstName.first!), rows: [contact])]))
                        }
                    }
                    tableView.reloadData()
                }
            }
        }
    }
    
    
//    func addToEmergency(contact:Contacts){
//        if emergencyContact.isEmpty {
//            LocalDataSource.shared.emergencyContact.append(SectionContent(sectionName: String(contact.firstName.first!), rows: [contact]))
//        }
//        else{
//            var bool = false
//            for i in 0..<LocalDataSource.shared.emergencyContact.count{
//                if (LocalDataSource.shared.emergencyContact[i].sectionName == String(contact.firstName.first!)){
//                    LocalDataSource.shared.emergencyContact[i].rows.append(contact)
//                    bool = true
//                }
//            }
//            if (!bool){
//                LocalDataSource.shared.emergencyContact.append(SectionContent(sectionName: String(contact.firstName.first!), rows: [contact]))
//            }
//        }
//        tableView.reloadData()
//    }
//    func addToFav(contact:Contacts){
//        if LocalDataSource.shared.favContacts.isEmpty {
//            LocalDataSource.shared.favContacts.append(SectionContent(sectionName: String(contact.firstName.first!), rows: [contact]))
//        }
//        else{
//            var bool = false
//            for i in 0..<LocalDataSource.shared.favContacts.count{
//                if (LocalDataSource.shared.favContacts[i].sectionName == String(contact.firstName.first!)){
//                    LocalDataSource.shared.favContacts[i].rows.append(contact)
//                    bool = true
//                }
//            }
//            if (!bool){
//                LocalDataSource.shared.favContacts.append(SectionContent(sectionName: String(contact.firstName.first!), rows: [contact]))
//            }
//        }
//        tableView.reloadData()
//    }
    
}





