//  InfoSheetViewController.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 31/03/23.
//

import UIKit

class InfoSheetViewController: UITableViewController, UINavigationControllerDelegate {
    
    lazy var isEditMode = false
    var isAddedByGrp:String?
    lazy var groupNames:[String] = []
    var editDelegate:EditDelegate?
    weak var allContactsVc:AllContactsVc?
    var isEdited = false
    var info:Contact?
    lazy var inputDict:[String:Any] = [:]
    
 
    var phoneNumRowIndex:Int?
    
    var addressRowIndex:Int?
    
    var socialProfileRowIndex:Int?
    
    var contact:Contact?
    
    var headerDataSource:[DataSource] = []

    
    
    lazy var photoLabel:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .gray
        imageView.layer.cornerRadius = 75
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
        return UIMenu(children: menuItems)
    }
    var editMenu : UIMenu {
        
        return UIMenu(title: "", children: [
            
            UIMenu(title: "Edit", children: [
                UIAction(title: "Camera", handler: { _ in
                    let vc = UIImagePickerController()
                    vc.sourceType = .camera
                    vc.delegate = self
                    vc.allowsEditing = true
                    self.present(vc, animated: true)
                }),
                UIAction(title: "Photos", handler: { _ in
                    let vc = UIImagePickerController()
                    vc.sourceType = .photoLibrary
                    vc.delegate = self
                    vc.allowsEditing = true
                    self.present(vc, animated: true)
                })
            ]),
            UIAction(title: "Delete", handler: { _ in
                self.photoLabel.image = UIImage(systemName: "person.circle.fill")
                self.addPhotoButton.setTitle("Add Photo", for: .normal)
                if #available(iOS 14.0, *) {
                    self.addPhotoButton.menu = self.buttonMenu
                } else {
                    // Fallback on earlier versions
                }
                self.inputDict[Headers.profileImage] = nil
                self.tableView.reloadData()
            })
        ])
    }
    init(contact:Contact?){
        super.init(style: .grouped)
        self.info = contact
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lazy  var fetchedData = DBHelper.fetchData()
        lazy var dbContactList = Helper.decodeToContact(list: fetchedData)
        lazy var localDataSource = Helper.extractNamesFromFetchedData(lists: Helper.sort(data: dbContactList))
        lazy var grpNames = DBHelper.fetchGrpNames(colName: "GROUP_NAME")
        groupNames = Helper.getGrpNames(grpName: grpNames)
        headerDataSource = Helper.getDs(grpCount: groupNames.count)
        if(info != nil){
            isEditMode = true
        }
        if(isEditMode){
            title = "Edit Contact"
        }
        else{
            title = "New Contact"
        }
       
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButton))
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
        if let grpName = isAddedByGrp {
            if var groups = info?.groups{
                groups.append(grpName)
                inputDict[Headers.groups] = groups
            }
            else{
                var tempGrpArr:[String] = []
                tempGrpArr.append(grpName)
                inputDict[Headers.groups] = tempGrpArr
            }

            
        }
        
        guard (isEditMode) else{
            //Edit functionality
            
            
            if let id = info?.contactId{
                inputDict[Headers.contactId] = id
            }
            if let image = info?.profileImage{
                inputDict[Headers.profileImage] = image
                photoLabel.image = UIImage(data: image)
                addPhotoButton.setTitle("Edit Photo", for: .normal)
                
                
                
                if #available(iOS 14.0, *) {
                    addPhotoButton.menu = editMenu
                } else {
                    // Fallback on earlier versions
                }
                
            }
            if let firstName = info?.firstName{
                inputDict[Headers.firstName] = firstName
            }
            if let lastName = info?.lastName{
                inputDict[Headers.lastName] = lastName
            }
            if let workInfo = info?.workInfo{
                var workInfoArr:[String] = []
                workInfoArr.append(workInfo)
                inputDict[Headers.workInfo]=workInfoArr
            }
            if let phoneNumber = info?.phoneNumber{
                inputDict[Headers.phoneNumber] = phoneNumber
            }
            if let email = info?.email{
                
                inputDict[Headers.email] = email
                
            }
            if let address = info?.address{
                
                inputDict[Headers.address]=address
            }
            if let socialProfile = info?.socialProfile{
                inputDict[Headers.socialProfile]=socialProfile
            }
            
            if let fav = info?.favourite{
                
                inputDict[Headers.favourite] = fav
            }
            if let emergencyContact = info?.emergencyContact{
                
                inputDict[Headers.emergencyContact] = emergencyContact
            }
            if let notes = info?.notes{
                inputDict[Headers.notes] = notes
            }
            if let groups = info?.groups{
                inputDict[Headers.groups] = groups
            }
            return
        }
    }
    
    
    
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (!isBeingDismissed){
            let alertController = UIAlertController(title: nil, message: "Are you sure you want to discard this new contact", preferredStyle: .actionSheet)
            
            let discardAction = UIAlertAction(title: "Discard changes", style: .destructive){ _ in
                
                self.dismiss(animated: true)
            }
            let editingAction = UIAlertAction(title: "Keep Editing", style: .cancel)
            alertController.addAction(discardAction)
            alertController.addAction(editingAction)
            
            present(alertController, animated: true)
            
            return
            
        }
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
    
    func setUpTableView(){
        tableView.allowsSelectionDuringEditing = true
        tableView.isEditing = true
        tableView.backgroundColor = .systemGroupedBackground
        
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
    func confifureCurrentGroups(){
        if let selectedGrps = inputDict[Headers.groups] as? [String]{
            for i in groupNames{
                if (!selectedGrps.contains(i)){
                    DBHelper.removeContactFromGrp(grpName: i, contactId: inputDict[Headers.contactId] as! Int)
                }
            }
        }
    }
    
    @objc func showOptions(sender:UIButton){
        phoneNumRowIndex = sender.tag
        let phone = PhoneNumOptionsTableView()
        phone.delegate = self
        present(UINavigationController(rootViewController: phone), animated: true)
    }
    @objc func addressOptions(sender:UIButton){
        
        addressRowIndex = sender.tag
        let addressVc = AddressTableViewController()
        addressVc.delegate = self
        present(UINavigationController(rootViewController: addressVc), animated: true)
        
    }
    @objc func socialProfileOptions(sender:UIButton){
        socialProfileRowIndex = sender.tag
        let vc = SocialProfileTableViewController()
        vc.delegate = self
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    @objc func tapFavourite(sender:UIButton){
        if let isFavourite = inputDict[Headers.favourite] as? Int{
            if (isFavourite == 0){
                sender.setTitle("Added to favourite", for: .normal)
                sender.setTitleColor(.systemBlue, for: .normal)
                inputDict[Headers.favourite] = 1
            }
            
            else{
                sender.setTitle("Add to favourite", for: .normal)
                sender.setTitleColor(.label, for: .normal)
                inputDict[Headers.favourite] = 0
            }
        }
        
        
    }
    @objc func tapEmergency(sender:UIButton){
        if let isEmergencyContact = inputDict[Headers.emergencyContact] as? Int{
            
            if (isEmergencyContact == 0){
                sender.setTitle("Added to emergency contact", for: .normal)
                sender.setTitleColor(.systemRed, for: .normal)
                inputDict[Headers.emergencyContact] = 1
            }
            
            else{
                sender.setTitle("Add to emergency contact", for: .normal)
                sender.setTitleColor(.label, for: .normal)
                inputDict[Headers.emergencyContact] = 0
            }
            
        }
        
    }
    @objc func cancelButton(){
        
        if(isEdited){
            let alertController = UIAlertController(title: nil, message: "Are you sure you want to discard this new contact", preferredStyle: .actionSheet)
            
            let discardAction = UIAlertAction(title: "Discard changes", style: .destructive){ _ in
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true)
            }
            let editingAction = UIAlertAction(title: "Keep Editing", style: .cancel)
            alertController.addAction(discardAction)
            alertController.addAction(editingAction)
            
            present(alertController, animated: true)
            
            return
        }
        if (isEditMode){
            navigationController?.popViewController(animated: true)
            dismiss(animated: true)
        }
        
        dismiss(animated: true)
    }
    
    @objc func DoneButton(){
        view.endEditing(true)
        
        //edit functionality
        if (isEditMode){
            let profimg = inputDict[Headers.profileImage] as? UIImage
            var addArr:[AddressModel] = []
            var phoneNumArr:[PhoneNumberModel] = []
            var socprofArr:[SocialProfileModel] = []
            
            if let workInfo = inputDict[Headers.workInfo] as? [String] {
                inputDict[Headers.workInfo] = workInfo[0]
            }
            if let address = inputDict[Headers.address] as? [AddressModel]{
                for i in address{
                    if i.doorNo != nil || i.Street != nil || i.city != nil || i.postcode != nil || i.state != nil || i.country != nil {
                        
                        addArr.append(i)
                    }
                }
            }
            if addArr.isEmpty {
                inputDict[ Headers.address] = nil
            }
            else{
                inputDict[Headers.address] = addArr
            }
            
            
            for i in inputDict[Headers.phoneNumber] as! [PhoneNumberModel] {
                if i.number != nil{
                    phoneNumArr.append(i)
                }
                inputDict[Headers.phoneNumber] = phoneNumArr
            }
            if let socialProfile =  inputDict[Headers.socialProfile] as? [SocialProfileModel]{
                for i in socialProfile{
                    if i.link != nil {
                        socprofArr.append(i)
                    }
                }
            }
            if socprofArr.isEmpty {
                inputDict[Headers.socialProfile] = nil
            }
            else{
                inputDict[Headers.socialProfile] = socprofArr
            }
            var emailArr:[String] = []
            if let email = inputDict[Headers.email] as? [String]{
                for i in email{
                    if (!i.isEmpty) {
                        emailArr.append(i)
                        
                    }
                }
            }
            if emailArr.isEmpty{
                inputDict[Headers.email] = nil
            }
            else{
                inputDict[Headers.email] = emailArr
            }
            
            confifureCurrentGroups()
            
            let newContact = Contact(contactId: inputDict[Headers.contactId] as! Int,profileImage: profimg?.pngData(), firstName: inputDict[Headers.firstName] as! String,lastName: inputDict[Headers.lastName] as? String,workInfo:  inputDict[Headers.workInfo] as? String,phoneNumber: (inputDict[Headers.phoneNumber] as! [PhoneNumberModel]),email: inputDict[Headers.email] as? [String],address: inputDict[Headers.address] as? [AddressModel],socialProfile: inputDict[Headers.socialProfile] as?[SocialProfileModel],favourite:inputDict[Headers.favourite] as? Int,emergencyContact: inputDict[Headers.emergencyContact] as? Int,notes: inputDict[Headers.notes] as? String ,groups: inputDict[Headers.groups] as? [String])
            
            DBHelper.updateContact(contact: newContact)
            allContactsVc?.refreshDataSource()
            allContactsVc?.tableView.reloadData()
            editDelegate?.getUpdatedContact(newContact: newContact)
            
            navigationController?.popViewController(animated: true)
            
            
            
        }
        // add functionality
        else{
            
            guard let firstName = inputDict[Headers.firstName] as? String
            else{
                let alertController = UIAlertController(title: nil, message: "First Name Field is Mandatory", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .cancel)
                
                alertController.addAction(okAction)
                
                present(alertController, animated: true)
                
                return
                
            }
            
            guard let _ = inputDict[Headers.phoneNumber] else{
                let alertController = UIAlertController(title: nil, message: "Mobile Number Field is Mandatory", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .cancel)
                
                alertController.addAction(okAction)
                
                present(alertController, animated: true)
                
                return
                
                
            }
            
            let dateformat = DateFormatter()
            dateformat.dateFormat = "ddmmss"
            guard let myInt = Int(dateformat.string(from: Date()))  else {
                print("Conversion failed.")
                return
            }
            inputDict[Headers.contactId] = myInt
            
            if let workInfo = inputDict[Headers.workInfo] as? [String]{
                inputDict[Headers.workInfo] = workInfo[0]
            }
            let image = inputDict[Headers.profileImage] as? UIImage
            if let groups = inputDict[Headers.groups] as? [String]{
                if (groups.count == 0){
                    inputDict[Headers.groups] = nil
                }
            }
            let newContact = Contact(
                contactId: inputDict[Headers.contactId] as! Int,
                profileImage: image?.pngData(),
                firstName:firstName,
                lastName: inputDict[Headers.lastName] as? String,
                workInfo:  inputDict[Headers.workInfo] as? String,
                phoneNumber: (inputDict[Headers.phoneNumber]) as! [PhoneNumberModel],
                email: (inputDict[Headers.email]) as? [String],
                address: (inputDict[Headers.address]) as? [AddressModel],
                socialProfile: (inputDict[Headers.socialProfile]) as? [SocialProfileModel],
                favourite:(inputDict[Headers.favourite] ) == nil ? 0:inputDict[Headers.favourite] as? Int ,
                emergencyContact:(inputDict[Headers.emergencyContact]) == nil ? 0: inputDict[Headers.emergencyContact] as? Int,
                notes: (inputDict[Headers.notes]) as? String  ,
                groups: inputDict[Headers.groups] as? [String])
            
            DBHelper.assignDb(contactList: newContact)
            
            allContactsVc?.refreshDataSource()
            
            
            
            dismiss(animated: true)
        }
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return headerDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Edit functionality
        if(isEditMode){
            if (section == 0){
                return 2
            }
            else if  headerDataSource[section].data[0] == Headers.workInfo{
                if let workInfoArr = inputDict[Headers.workInfo] as? [String]{
                    return  (workInfoArr.count+1)
                }
                else{
                    return 1
                }
            }
            else if headerDataSource[section].data[0] == Headers.email{
                if let email = inputDict[Headers.email] as? [String]{
                    return  (email.count+1)
                }
                else{
                    return 1
                }
            }
            else if headerDataSource[section].data[0] == Headers.phoneNumber {
                if let number = inputDict[Headers.phoneNumber] as? [PhoneNumberModel]{
                    return  (number.count+1)
                }
                else{
                    return 1
                }
            }
            else if headerDataSource[section].data[0] == Headers.address{
                if let address = inputDict[Headers.address] as? [AddressModel]{
                    return  (address.count+1)
                }
                else{
                    return 1
                }
                
            }
            else if headerDataSource[section].data[0] == Headers.socialProfile{
                if let socialProfile = inputDict[Headers.socialProfile] as? [SocialProfileModel]{
                    return  (socialProfile.count+1)
                }
                else{
                    return 1
                }
            }
            else if headerDataSource[section].data[0] == Headers.groups{
                return (groupNames.count)+1
            }
            
            else{
                return 1
            }
        }
        
        // Add Functionality
        else{
            if(section == 0){
                return 2
            }
            else{
                switch headerDataSource[section].data[0]{
                case Headers.workInfo:
                    if let workInfoArr = inputDict[Headers.workInfo] as? [String]{
                        return  (workInfoArr.count+1)
                    }
                    else{
                        return 1
                    }
                    
                case Headers.phoneNumber:
                    if let number = inputDict[Headers.phoneNumber] as? [PhoneNumberModel]{
                        return  (number.count+1)
                    }
                    else{
                        return 1
                    }
                case Headers.email:
                    if let email = inputDict[Headers.email] as? [String]{
                        return  (email.count+1)
                    }
                    else{
                        return 1
                    }
                case Headers.address:
                    if let address = inputDict[Headers.address] as? [AddressModel]{
                        return  (address.count+1)
                    }
                    else{
                        return 1
                    }
                case Headers.socialProfile:
                    if let socialProfile = inputDict[Headers.socialProfile] as? [SocialProfileModel]{
                        return  (socialProfile.count+1)
                    }
                    else{
                        return 1
                    }
                case Headers.groups:
                    return groupNames.count+1
                    
                default:
                    return 1
                }
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        if headerDataSource[indexPath.section].data[0] == Headers.favourite  || headerDataSource[indexPath.section].data[0] == Headers.emergencyContact  || headerDataSource[indexPath.section].data[0] == Headers.notes  || (headerDataSource[indexPath.section].data[0] == Headers.groups ){
            
            return UITableViewCell.EditingStyle.none
        }
        
        
        else if indexPath.section > 0 && indexPath.row > 0 && headerDataSource[indexPath.section].data[0] != Headers.groups  {
            return UITableViewCell.EditingStyle.delete
        }
        
        else if ( indexPath.section > 0 || (headerDataSource[indexPath.section].data[0] == Headers.groups  && indexPath.row > 0)){
            return  UITableViewCell.EditingStyle.insert
        }
        
        else{
            return UITableViewCell.EditingStyle.none
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .insert{
            // if section header is not equal to groups
            if(headerDataSource[indexPath.section].data[0] != Headers.groups ){
                if (headerDataSource[indexPath.section].data[0] == Headers.workInfo){
                    var tempWorkInfoArr:[String] = []
                    tempWorkInfoArr.append("")
                    inputDict[Headers.workInfo] = tempWorkInfoArr
                    
                    
                }
                else if (headerDataSource[indexPath.section].data[0] == Headers.phoneNumber ){
                    var tempPhoneArr:[PhoneNumberModel] = []
                    tempPhoneArr.append(PhoneNumberModel(modelType: "mobile"))
                    inputDict[Headers.phoneNumber] = tempPhoneArr
                }
                else if (headerDataSource[indexPath.section].data[0] == Headers.email ){
                    var tempEmailArr:[String] = []
                    tempEmailArr.append("")
                    inputDict[Headers.email] = tempEmailArr
                }
                else if (headerDataSource[indexPath.section].data[0] == Headers.address ){
                    var tempAddArr:[AddressModel] = []
                    tempAddArr.append(AddressModel(modelType: "home"))
                    inputDict[Headers.address] = tempAddArr
                    
                }
                else if (headerDataSource[indexPath.section].data[0] == Headers.socialProfile ) {
                    var tempSocialProfileArr:[SocialProfileModel] = []
                    tempSocialProfileArr.append(SocialProfileModel(profileType: "Twitter"))
                    inputDict[Headers.socialProfile] = tempSocialProfileArr
                }
                tableView.reloadData()
                
            }
            // if sec header is equal to groups
            else{
                if var groups = info?.groups{
                    groups.append(groupNames[indexPath.row])
                    inputDict[Headers.groups] = groups
                }
                
            }
        }
        else if editingStyle == .delete {
            if (headerDataSource[indexPath.section].data[0] == Headers.workInfo ){
                var workInfoToBeEdited:[String] = inputDict[Headers.workInfo] as! [String]
                workInfoToBeEdited.remove(at: indexPath.row - 1)
                inputDict[Headers.workInfo] = workInfoToBeEdited
            }
            else if (headerDataSource[indexPath.section].data[0] == Headers.phoneNumber ){
                var phoneNumToBeEdited:[PhoneNumberModel] = inputDict[Headers.phoneNumber] as! [PhoneNumberModel]
                phoneNumToBeEdited.remove(at: indexPath.row - 1)
                inputDict[Headers.phoneNumber] = phoneNumToBeEdited
            }
            else if (headerDataSource[indexPath.section].data[0] == Headers.email ){
                var emailToBeEdited:[String] = inputDict[Headers.email] as! [String]
                emailToBeEdited.remove(at: indexPath.row - 1)
                inputDict[Headers.email] = emailToBeEdited
            }
            else if (headerDataSource[indexPath.section].data[0] == Headers.address ){
                var addressToBeEdited:[AddressModel] = inputDict[Headers.address] as! [AddressModel]
                addressToBeEdited.remove(at: indexPath.row - 1)
                inputDict[Headers.address] = addressToBeEdited
                
            }
            else if (headerDataSource[indexPath.section].data[0] == Headers.socialProfile){
                var socialProfileToBeEdited:[SocialProfileModel] = inputDict[Headers.socialProfile] as! [SocialProfileModel]
                socialProfileToBeEdited.remove(at: indexPath.row - 1)
                inputDict[Headers.socialProfile] = socialProfileToBeEdited
            }
            
            tableView.reloadData()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if (indexPath.section == 0 || headerDataSource[indexPath.section].data[0] == Headers.favourite || headerDataSource[indexPath.section].data[0] == Headers.emergencyContact || headerDataSource[indexPath.section].data[0] == Headers.notes || headerDataSource[indexPath.section].data[0] == Headers.groups) {
            return false
        }
        
        if(headerDataSource[indexPath.section].data[0] == Headers.groups && indexPath.row == 0){
            return false
        }
        
        else{
            return true
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard (indexPath.section != 0) else{
            // if section == 0
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ContactNameTableViewCell.identifier, for: indexPath) as? ContactNameTableViewCell
            cell?.contentView.layoutMargins = UIEdgeInsets.zero
            // edit functionality
            if(isEditMode){
                if (indexPath.row == 0){
                    if let firstName = inputDict[Headers.firstName] as? String{
                        cell?.textField.text = firstName
                        
                    }
                    else{
                        cell?.textField.text = nil
                    }
                }
                else if (indexPath.row == 1){
                    
                    if let lastName = inputDict[Headers.lastName] as? String{
                        cell?.textField.text = lastName
                        
                    }
                    else{
                        cell?.textField.text = nil
                    }
                    
                }
            }
            // add functionality
            else{
                
                
                if inputDict[Headers.firstName] != nil && indexPath.row == 0 {
                    if let firstName = inputDict[Headers.firstName]{
                        cell?.textField.text = firstName as? String
                    }
                    else{
                        cell?.textField.text = nil
                    }
                }
                
                else if inputDict[Headers.lastName] != nil && indexPath.row == 1{
                    if let lastName = inputDict[Headers.lastName]{
                        cell?.textField.text = lastName as? String
                    }
                    else{
                        cell?.textField.text = nil
                    }
                }
                else{
                    cell?.textField.text = nil
                }
            }
            
            
            cell?.textField.attributedPlaceholder = NSAttributedString(string:(headerDataSource[indexPath.section].data[indexPath.row]) ,attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
            cell?.textField.delegate = self
            
            return cell!
        }
        
        
        
        if (headerDataSource[indexPath.section].data[0] == Headers.phoneNumber && indexPath.row > 0){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: PhoneNumberTableViewCell.identifier, for: indexPath) as? PhoneNumberTableViewCell
            if let phoneNumber = inputDict[Headers.phoneNumber] as? [PhoneNumberModel]{
                cell?.optionLabel.text = phoneNumber[indexPath.row-1].modelType
            }
            
            cell?.cellView.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
            cell?.cellView.tag = indexPath.row
            cell?.numInput.delegate = self
            cell?.numInput.tag = indexPath.row
            
            if let number = inputDict[Headers.phoneNumber] as? [PhoneNumberModel]{
                if let numInInt = number[indexPath.row - 1].number{
                    cell?.numInput.text = String(numInInt)
                }
            }
            
            
            cell?.numInput.attributedPlaceholder = NSAttributedString(string:Headers.phoneNumber,attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.5)])
            return cell!
        }
        
        
        else if(headerDataSource[indexPath.section].data[0] == Headers.address && indexPath.row > 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: AddressTableViewCell.identifier, for: indexPath) as? AddressTableViewCell
            if let address = inputDict[Headers.address] as? [AddressModel]{
                cell?.optionLabel.text = address[indexPath.row-1].modelType
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
                
                if let doorNo = address[indexPath.row - 1].doorNo{
                    cell?.doorNumTf.text = String(doorNo)
                    
                }
                if let street = address[indexPath.row - 1].Street{
                    cell?.streetTf.text = street
                    
                }
                if let city = address[indexPath.row - 1].city{
                    cell?.cityTf.text = city
                    
                }
                if let postcode = address[indexPath.row - 1].postcode{
                    cell?.postCodeTf.text = String(postcode)
                    
                }
                if let state = address[indexPath.row - 1].state{
                    cell?.stateTf.text = state
                    
                }
                if let country = address[indexPath.row - 1].country{
                    cell?.CountryTf.text = country
                    
                }
                
            }
            
            return cell!
        }
        
        else if (headerDataSource[indexPath.section].data[0] == Headers.socialProfile && indexPath.row > 0){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SocialProfileTableViewCell.identifier, for: indexPath) as? SocialProfileTableViewCell
            if let socialProfile = inputDict[Headers.socialProfile] as? [SocialProfileModel]{
                cell?.optionLabel.text = socialProfile[indexPath.row-1].profileType
                
                cell?.cellView.tag = indexPath.row
                cell?.numInput.keyboardType = .emailAddress
                cell?.numInput.delegate = self
                cell?.numInput.tag = indexPath.row
                
                cell?.cellView.addTarget(self, action: #selector(socialProfileOptions), for: .touchUpInside)
                
                if let link = socialProfile[indexPath.row - 1].link{
                    cell?.numInput.text = String(link)
                }
            }
            cell?.numInput.attributedPlaceholder = NSAttributedString(string:Headers.socialProfile,attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.5)])
            return cell!
        }
        
        else if (headerDataSource[indexPath.section].data[0] == Headers.notes ){
            let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.identifier) as! NotesTableViewCell
            if let notes = inputDict[Headers.notes] as? String{
                cell.textView.text = notes
            }
            else{
                cell.textView.text = Headers.notes
            }
            
            cell.textView.delegate = self
            return cell
            
        }
        else if (headerDataSource[indexPath.section].data[0] == Headers.favourite){
            let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteAndEmergencyContactTableViewCell.identifier) as! FavouriteAndEmergencyContactTableViewCell
            if (inputDict[Headers.favourite] == nil){
                inputDict[Headers.favourite] = 0
            }
            cell.textButton.addTarget(self, action: #selector(tapFavourite), for: .touchUpInside)
            if let isFavourite = inputDict[Headers.favourite] as? Int{
                if (isFavourite == 0){
                    
                    cell.textButton.setTitle("Add to favourite", for: .normal)
                    cell.textButton.setTitleColor(.label, for: .normal)
                }
                
                else{
                    cell.textButton.setTitle("Added to favourite", for: .normal)
                    cell.textButton.setTitleColor(.systemBlue, for: .normal)
                }
            }
            
            return cell
        }
        else if (headerDataSource[indexPath.section].data[0] == Headers.emergencyContact ){
            let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteAndEmergencyContactTableViewCell.identifier) as! FavouriteAndEmergencyContactTableViewCell
            if (inputDict[Headers.emergencyContact] == nil){
                inputDict[Headers.emergencyContact] = 0
            }
            cell.textButton.addTarget(self, action: #selector(tapEmergency), for: .touchUpInside)
            if let isEmergencyContact = inputDict[Headers.emergencyContact] as? Int{
                if(isEmergencyContact == 0){
                    cell.textButton.setTitle("Add to emergency Contact", for: .normal)
                    cell.textButton.setTitleColor(.label, for: .normal)
                }
                else{
                    cell.textButton.setTitle("Added to emergency contact", for: .normal)
                    cell.textButton.setTitleColor(.systemRed, for: .normal)
                }
            }
            
            return cell
        }
        else if (headerDataSource[indexPath.section].data[0] == Headers.groups && indexPath.row > 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: GroupsTableViewCell.identifier) as! GroupsTableViewCell
            cell.selectionStyle = .blue
            

            let current = groupNames[indexPath.row - 1]
            if let groups = inputDict[Headers.groups] as? [String]{
                
                if(groups.count != 0){
                    let isUserSelected = groups.contains(current)
                    if (isUserSelected){
                        cell.leftSideButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                        cell.leftSideButton.tintColor = .systemGreen
                        
                    }
                    else{
                        cell.leftSideButton.setImage(UIImage(systemName: "circle"), for: .normal)
                        cell.leftSideButton.tintColor = .systemGreen
                    }
                }
                else{
                    cell.leftSideButton.setImage(UIImage(systemName: "circle"), for: .normal)
                    cell.leftSideButton.tintColor = .systemGreen
                }
            }
            else{
                    cell.leftSideButton.setImage(UIImage(systemName: "circle"), for: .normal)
                    cell.leftSideButton.tintColor = .systemGreen
            }
            
 
            cell.label.text = groupNames[indexPath.row - 1]
            cell.label.textColor = .label
            return cell
        }
        else if (headerDataSource[indexPath.section].data[0] == Headers.workInfo && indexPath.row > 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: AddTableViewCell.identifier, for: indexPath) as! AddTableViewCell
            
            cell.textField.tag = indexPath.row - 1
            if let workInfoArr = inputDict[Headers.workInfo] as? [String]{
                cell.textField.text = workInfoArr[indexPath.row - 1]
            }
            cell.textField.attributedPlaceholder = NSAttributedString(string: (headerDataSource[indexPath.section].data[0]),attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.5)])
            
            cell.textField.delegate = self
            
            return cell
            
            
        }
        else if (headerDataSource[indexPath.section].data[0] == Headers.email && indexPath.row > 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: AddTableViewCell.identifier, for: indexPath) as! AddTableViewCell
            cell.textField.tag =  indexPath.row - 1
            if let emailArr = inputDict[Headers.email] as? [String]{
                if indexPath.row-1 < emailArr.count {
                    cell.textField.text = emailArr[indexPath.row-1]
                }
                
            }
            cell.textField.attributedPlaceholder = NSAttributedString(string: (headerDataSource[indexPath.section].data[0]),attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.5)])
            
            cell.textField.delegate = self
            
            return cell
        }
        
        
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as! InfoTableViewCell
            cell.textLabels.text = headerDataSource[indexPath.section].data[indexPath.row]
            
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
        
        if ( headerDataSource[indexPath.section].data[0] == Headers.address  && indexPath.row > 0){
            return 300.0
        }
        else if headerDataSource[indexPath.section].data[0] == Headers.notes {
            return 150.0
        }
        else{
            return 60.0
        }
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if(indexPath.row == 0){
            if (headerDataSource[indexPath.section].data[0] == Headers.workInfo){
                
                if(inputDict[Headers.workInfo] == nil){
                    var tempWorkInfoArr:[String] = []
                    tempWorkInfoArr.append("")
                    inputDict[Headers.workInfo] = tempWorkInfoArr
                }
                else{
                    let alertController = UIAlertController(title: nil, message: "Work Info Field should have only one value", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: .default)
                    
                    alertController.addAction(okAction)
                    
                    present(alertController, animated: true)
                    
                    return
                }
                
            }
            
            
            else if (headerDataSource[indexPath.section].data[0] == Headers.phoneNumber ){
                var tempPhoneArr:[PhoneNumberModel] = []
                if let number = inputDict[Headers.phoneNumber] as? [PhoneNumberModel]{
                    
                    tempPhoneArr = number
                }
                
                tempPhoneArr.append(PhoneNumberModel(modelType: "mobile"))
                inputDict[Headers.phoneNumber] = tempPhoneArr
                
            }
            else if (headerDataSource[indexPath.section].data[0] == Headers.email){
                var tempEmailArr:[String] = []
                if let email = inputDict[Headers.email] as? [String]{
                    
                    tempEmailArr = email
                }
                
                tempEmailArr.append("")
                inputDict[Headers.email] = tempEmailArr
                
            }
            else if (headerDataSource[indexPath.section].data[0] == Headers.address ){
                var tempAddArr:[AddressModel] = []
                if let address = inputDict[Headers.address] as? [AddressModel]{
                    
                    tempAddArr = address
                }
                
                tempAddArr.append(AddressModel(modelType: "home"))
                inputDict[Headers.address] = tempAddArr
                
                
            }
            else if (headerDataSource[indexPath.section].data[0] == Headers.socialProfile ) {
                
                var tempSocialProfileArr:[SocialProfileModel] = []
                if let socialProfile = inputDict[Headers.socialProfile] as? [SocialProfileModel]{
                    
                    tempSocialProfileArr = socialProfile
                }
                
                tempSocialProfileArr.append(SocialProfileModel(profileType: "Twitter"))
                inputDict[Headers.socialProfile] = tempSocialProfileArr
                
            }
            else if (headerDataSource[indexPath.section].data[0] == Headers.favourite){
                
                if let isFavourite = inputDict[Headers.favourite] as? Int{
                    if(isFavourite == 0){
                        inputDict[Headers.favourite] = 1
                    }
                    else{
                        inputDict[Headers.favourite]  = 0
                    }
                }
                
                
            }
            else if (headerDataSource[indexPath.section].data[0] == Headers.emergencyContact){
                
                if let isEmergencyContact = inputDict[Headers.emergencyContact] as? Int{
                    if(isEmergencyContact == 0){
                        inputDict[Headers.emergencyContact]  = 1}
                    else{
                        inputDict[Headers.emergencyContact]  = 0
                    }
                }
                
            }
        }
        
        else{
            if (headerDataSource[indexPath.section].data[0] == Headers.groups  && indexPath.row > 0){
                
                let userClicked = groupNames[indexPath.row - 1]
                
                if let groups = inputDict[Headers.groups] as? [String]{
                    if (groups.contains(userClicked)){
                        for i in 0..<groups.count{
                            if(groups[i] == userClicked){
                                var temp = groups
                                temp.remove(at: i)
                                inputDict[Headers.groups] = temp
                            }
                        }
                        
                        
                    }
                    else{
                        var tempGrpArr:[String] = groups
                        tempGrpArr.append(groupNames[indexPath.row - 1])
                        inputDict[Headers.groups] = tempGrpArr
                    }
                }
                    
                        else{
                            var tempGrpArr:[String] = []
                            tempGrpArr.append(groupNames[indexPath.row - 1])
                            inputDict[Headers.groups] = tempGrpArr
                            
                        }

                    
                
                
                
                
                
            }
            
        }
        
        tableView.reloadData()
        
    }
    
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    
}


extension InfoSheetViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isEdited = true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let field = textField.attributedPlaceholder?.string else {
            return
        }
        switch field{
            
            
        case Headers.firstName, Headers.lastName:
            if let value = textField.text{
                inputDict[field] = value.isEmpty ? nil: value
            }
            
            
        case Headers.firstName:
            
            if let firstName = textField.text{
                if firstName != ""{
                    inputDict[Headers.firstName] = firstName}
                else{
                    inputDict[Headers.firstName] = nil
                }
            }
            
            
        case Headers.lastName:
            
            if let lastName = textField.text {
                
                if lastName != ""{
                    inputDict[Headers.lastName] = lastName
                }
                else{
                    inputDict[Headers.lastName] = nil
                }
            }
            
        case Headers.workInfo:
            
            if let workInfo = textField.text{
                if var workInfoArr = inputDict[Headers.workInfo] as? [String]{
                    workInfoArr[textField.tag] = workInfo
                    inputDict[Headers.workInfo] = workInfoArr
                }
                
                
            }
            
            
            
        case Headers.email:
            if let email = textField.text{
                if email != ""{
                    if var emailArr = inputDict[Headers.email] as? [String]{
                        emailArr[textField.tag] = email
                        inputDict[Headers.email] = emailArr
                    }
                }
            }
            
            
        case Headers.phoneNumber:
            if let phoneNumber = textField.text {
                
                let result = String(phoneNumber).range(
                    of: #"^\d{1,10}$"#,
                    options: .regularExpression
                )
                if(result != nil){
                    if var number = inputDict[Headers.phoneNumber] as? [PhoneNumberModel]{
                        number[textField.tag - 1].number = Int64(phoneNumber)
                        inputDict[Headers.phoneNumber] = number
                    }
                    
                    
                }
                else{
                    let alertController = UIAlertController(title: "Invalid Phone Number", message: "Phone number should not contain alphabets!", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .cancel)
                    alertController.addAction(okAction)
                    
                    present(alertController, animated: true)
                    
                    return
                    
                }
                
            }
            
        case "Door no." :
            
            if var address = inputDict[Headers.address] as? [AddressModel]{
                if let doorNo = textField.text{
                    address[textField.tag - 1].doorNo = doorNo
                    inputDict[Headers.address] = address
                }
            }
            
            
        case "Street":
            if var address = inputDict[Headers.address] as? [AddressModel]{
                if let street = textField.text{
                    address[textField.tag - 1].Street = street
                    inputDict[Headers.address] = address
                }
            }
            
            
        case "City":
            if var address = inputDict[Headers.address] as? [AddressModel]{
                if let city = textField.text{
                    address[textField.tag - 1].city = city
                    inputDict[Headers.address] = address
                }
            }
            
            
        case "PostCode":
            if var address = inputDict[Headers.address] as? [AddressModel]{
                if let postCode = textField.text{
                    address[textField.tag - 1].postcode = postCode
                    inputDict[Headers.address] = address
                }
            }
            
        case "State":
            if var address = inputDict[Headers.address] as? [AddressModel]{
                if let state = textField.text{
                    address[textField.tag - 1].state = state
                    inputDict[Headers.address] = address
                }
            }
            
            
        case "Country":
            if var address = inputDict[Headers.address] as? [AddressModel]{
                if let country = textField.text{
                    address[textField.tag - 1].country = country
                    inputDict[Headers.address] = address
                }
            }
            
        case Headers.socialProfile:
            
            if let socialProfile = textField.text{
                if var socialProfileArr = inputDict[Headers.socialProfile] as? [SocialProfileModel] {
                    socialProfileArr[textField.tag - 1].link = socialProfile
                    inputDict[Headers.socialProfile] = socialProfileArr
                }
            }
            
        default:
            return
        }
        
        textField.resignFirstResponder()
        print(inputDict)
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



extension InfoSheetViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray && textView.text == Headers.notes {
            textView.text = ""
            
        }
        textView.textColor = UIColor.label
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        let txt = textView.text as? NSString
        let str = txt?.replacingCharacters(in: range , with: text)
        if str == "" {
            textView.text = Headers.notes
            textView.textColor = UIColor.gray
            textView.resignFirstResponder()
            inputDict[Headers.notes] = nil
        }
        else{
            inputDict[Headers.notes] = str
        }
        
        return true
    }
    
}



extension InfoSheetViewController:Delegate{
    
    func getOptions(option: String,type: String) {
        if type == Headers.phoneNumber {
            
            if var phoneNumber = inputDict[Headers.phoneNumber] as? [PhoneNumberModel]{
                if let index = phoneNumRowIndex{
                    phoneNumber[index - 1].modelType = option
                    inputDict[Headers.phoneNumber] = phoneNumber
                }
            }
            
        }
        else if type == Headers.address{
            if var address = inputDict[Headers.address] as? [AddressModel]{
                if let index = addressRowIndex{
                    address[index - 1].modelType = option
                    inputDict[Headers.address] = address
                }
            }
            //            addressModel[addressRowIndex! - 1].modelType = option
            
        }
        
        else if type == Headers.socialProfile{
            if var socialProfile = inputDict[Headers.socialProfile] as? [SocialProfileModel]{
                if let index = socialProfileRowIndex{
                    socialProfile[index - 1].profileType = option
                    inputDict[Headers.socialProfile] = socialProfile
                }
            }
        }
        tableView.reloadData()
        
        
    }
}
extension InfoSheetViewController:ImageDelegate{
    func getImage(images: UIImage) {
        
        photoLabel.image = images
        inputDict[Headers.profileImage] = images
        photoLabel.layer.cornerRadius = photoLabel.frame.size.width / 2
        photoLabel.layer.masksToBounds = true
        
    }
}
extension InfoSheetViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let images = info[.editedImage] as? UIImage{
            photoLabel.image = images
            inputDict[Headers.profileImage] = images
            photoLabel.layer.cornerRadius = 75
            photoLabel.layer.masksToBounds = true
            
        }
        
        
        picker.dismiss(animated: true)
        addPhotoButton.setTitle("Edit Photo", for: .normal)
        if #available(iOS 14.0, *) {
            addPhotoButton.menu = editMenu
        } else {
            // Fallback on earlier versions
        }
    }
    
}
