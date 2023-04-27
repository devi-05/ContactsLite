//  InfoSheetViewController.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 31/03/23.
//

import UIKit
protocol TitleDelegate{
    func setTitle(string:String)
}

class InfoSheetViewController: UITableViewController, UINavigationControllerDelegate ,ImageDelegate,TitleDelegate, UIImagePickerControllerDelegate{
    func setTitle(string: String) {
        title = string
    }
    
    var isAddedByGrp:String?
    lazy var groupNames:[String] = []
    var editDelegate:editDelegate?
    var selectedGrpIndex:[Int] = []
    weak var allContactsVc:AllContactsVc?
    var isEdited = false
    var info:Contacts?
    var inputDict:[String:Any] = [:]{
        didSet{
            print(inputDict)
        }
    }
    
    init(contact:Contacts?){
        super.init(nibName: nil, bundle: nil)
        self.info = contact
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    var id:Int?
    var image:UIImage?
    
    var workInfoArray:[String] = []
    var emailArray:[String] = []
    var isFavourite:Int = 0
    var isEmergencyContact:Int = 0
    
    
    var groups:[String] = []
    
   
    var phoneNumRowIndex:Int?
    
    var addressRowIndex:Int?
    
    var socialProfileRowIndex:Int?
    
    var phoneNumModel:[PhoneNumberModel] = []
    
    var addressModel:[AddressModel] = []
    
    var socialProfileModel:[SocialProfileModel] = []
    
    var contactsList:[Contacts] = []
    
    var contact:Contacts?
    
    
    
   
    
    
    
    var headerDataSource:[DataSource] = [
        DataSource(data: [Headers.firstName,Headers.lastName]),
        DataSource(data: [Headers.workInfo]),
        DataSource(data: [Headers.phoneNumber]),
        DataSource(data: [Headers.email]),
        DataSource(data: [Headers.address]),
        DataSource(data: [Headers.socialProfile]),
        DataSource(data: [Headers.notes]),
        DataSource(data: [Headers.groups]),
        DataSource(data: [Headers.favourite]),
        DataSource(data: [Headers.emergencyContact])]
    
    
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
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if(info == nil){
//            inputDict = [:]
//        }
        lazy  var fetchedData = DBHelper.fetchData()
        lazy var dbContactList = Helper.decodeToContact(list: fetchedData)
        lazy var localDataSource = Helper.extractNamesFromFetchedData(lists: Helper.sort(data: dbContactList))
        lazy var grpNames = DBHelper.fetchGrpNames(colName: "GROUP_NAME")
        groupNames = Helper.getGrpNames(grpName: grpNames)
        if (groupNames.count == 0){
            headerDataSource.remove(at: 7)
        }

        for i in 0..<groupNames.count{
            if let grpName = isAddedByGrp{
                if groupNames[i] == grpName{
                    selectedGrpIndex.append(i+1)
                }
            }
        }
        if (info != nil){
            inputDict[Headers.groups] = groupNames
            if let grps = info?.groups{
                for i in grps{
                    for j in 0..<groupNames.count{
                        if i == groupNames[j]{
                            selectedGrpIndex.append(j+1)
                        }
                    }
                }
            }
        }
        inputDict[Headers.contactId] = info?.contactId
        tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        print("inputdict in viewdidappear : \(inputDict)")
        print("did appear")
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
            groups.append(grpName)
            
        }

        guard (info == nil) else{
            //Edit functionality
            id = info?.contactId
            if(info?.profileImage != nil){
                
                image = UIImage(data: (info?.profileImage)!)
                photoLabel.image = image
                addPhotoButton.setTitle("Edit Photo", for: .normal)
                var menuItems: [UIAction] {
                    return [
                        UIAction(title: "Edit", image: UIImage(systemName: "pencil"), handler: { (_) in
                            print("edit")
                            let alertController = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .alert)
                            
                            let camAction = UIAlertAction(title: "Camera", style: .destructive){ _ in
                                let vc = UIImagePickerController()
                                vc.sourceType = .camera
                                vc.delegate = self
                                vc.allowsEditing = true
                                self.present(vc, animated: true)
                            }
                        
                            let photoAction = UIAlertAction(title: "Photos", style: .cancel) { (_) in
                                let vc = UIImagePickerController()
                                vc.sourceType = .photoLibrary
                                vc.delegate = self
                                vc.allowsEditing = true
                                self.present(vc, animated: true)
                            }
                            alertController.addAction(camAction)
                            alertController.addAction(photoAction)
                            
                            self.present(alertController, animated: true)
                            
                            return
                           
                        }),
                        UIAction(title: "Delete", image: UIImage(systemName: "trash"), handler: { (_) in
                            self.photoLabel.image = UIImage(systemName: "person.circle.fill")
                            self.inputDict[Headers.profileImage] = nil
//                            self.tableView.reloadData()
                        })
                       
                    ]
                }
                
                var buttonMenu: UIMenu {
                    return UIMenu(children: menuItems)
                }
                if #available(iOS 14.0, *) {
                    addPhotoButton.menu = buttonMenu
                } else {
                    // Fallback on earlier versions
                }
                inputDict[Headers.profileImage] = image
                
            }
            if let firstName = info?.firstName{
                inputDict[Headers.firstName] = firstName
            }
            if let lastName = info?.lastName{
                inputDict[Headers.lastName] = lastName
            }
            if let workInfo = info?.workInfo{
                workInfoArray.append(workInfo)
                inputDict[Headers.workInfo]=workInfoArray[0]
            }
            if let phoneNumber = info?.phoneNumber{
                phoneNumModel = phoneNumber
                inputDict[Headers.phoneNumber] = phoneNumModel
            }
            if let email = info?.email{
                
                    emailArray = email
                    inputDict[Headers.email] = emailArray
                
            }
            if let address = info?.address{
                addressModel = address
                inputDict[Headers.address]=addressModel
            }
            if let socialProfile = info?.socialProfile{
                socialProfileModel = socialProfile
                inputDict[Headers.socialProfile]=socialProfile
            }
           
            if let grps = info?.groups{
                for i in grps{
                    groups.append(i)

                }

            }
            if let fav = info?.favourite{
                isFavourite = fav
                inputDict[Headers.favourite] = isFavourite
            }
            if let emergencyContact = info?.emergencyContact{
                isEmergencyContact = emergencyContact
                inputDict[Headers.emergencyContact] = isEmergencyContact
            }
            if let notes = info?.notes{
                inputDict[Headers.notes] = notes
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
            let editingAction = UIAlertAction(title: "Keep Editing", style: .cancel){ _ in
                    
    //                        self.dismiss(animated: true)
                }
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
        tableView.backgroundColor = .secondarySystemBackground
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
        
        // Edit functionality
        if(info != nil){
            if (section == 0){
                return 2
            }
            else if  headerDataSource[section].data[0] == Headers.workInfo{
                return (!workInfoArray.isEmpty) ? workInfoArray.count+1 : 1
            }
            else if headerDataSource[section].data[0] == Headers.email{
                return (!emailArray.isEmpty) ? emailArray.count+1 : 1
            }
            else if headerDataSource[section].data[0] == Headers.phoneNumber {
                return (phoneNumModel.count)+1
            }
            else if headerDataSource[section].data[0] == Headers.address{
                return (addressModel.count)+1
            }
            else if headerDataSource[section].data[0] == Headers.socialProfile{
                return (socialProfileModel.count)+1
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
                    return  (workInfoArray.count+1)
                case Headers.phoneNumber:
                    return  (phoneNumModel.count+1)
                case Headers.email:
                    return  (emailArray.count+1)
                case Headers.address:
                    return (addressModel.count+1)
                case Headers.socialProfile:
                    return (socialProfileModel.count+1)
                case Headers.favourite:
                    return 1
                case Headers.emergencyContact:
                    return 1
                case Headers.notes:
                    return 1
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
                    if(workInfoArray.isEmpty){
                        workInfoArray.append("")
                    }
                   
                    
                }
                else if (headerDataSource[indexPath.section].data[0] == Headers.phoneNumber ){
                    phoneNumModel.append(PhoneNumberModel(modelType: "mobile"))
                }
                else if (headerDataSource[indexPath.section].data[0] == Headers.email ){
                    
                    emailArray.append("")
                }
                else if (headerDataSource[indexPath.section].data[0] == Headers.address ){
                    addressModel.append(AddressModel(modelType: "home"))
                    
                }
                else if (headerDataSource[indexPath.section].data[0] == Headers.socialProfile ) {                    socialProfileModel.append(SocialProfileModel(profileType: "Twitter"))
                }
                
                
                tableView.reloadData()
                
            }
            // if sec header is equal to groups
            else{
                groups.append(groupNames[indexPath.row])
                
            }
        }
        else if editingStyle == .delete {
            if (headerDataSource[indexPath.section].data[0] == Headers.workInfo ){
                
                workInfoArray.remove(at: indexPath.row - 1)
                inputDict[Headers.workInfo] = workInfoArray
                
            }
            else if (headerDataSource[indexPath.section].data[0] == Headers.phoneNumber ){
                phoneNumModel.remove(at: indexPath.row - 1)
                inputDict[Headers.phoneNumber] = phoneNumModel
            }
            else if (headerDataSource[indexPath.section].data[0] == Headers.email ){
                emailArray.remove(at: indexPath.row - 1)
                inputDict[Headers.email] = emailArray
            }
            else if (headerDataSource[indexPath.section].data[0] == Headers.address ){
                if (!addressModel.isEmpty){
                    addressModel.remove(at: indexPath.row - 1)
                    inputDict[Headers.address] = addressModel
                }
            }
            else if (headerDataSource[indexPath.section].data[0] == Headers.socialProfile){
                if (!socialProfileModel.isEmpty){
                    socialProfileModel.remove(at: indexPath.row - 1)
                    inputDict[Headers.socialProfile] = socialProfileModel
                }
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
            if(info != nil){
                if (indexPath.row == 0){
                    if let firstName = inputDict[Headers.firstName] as? String{
                        cell?.textField.text = firstName
                        //                    inputDict[Headers.firstName] = info?.firstName
                    }
                    else{
                        cell?.textField.text = nil
                    }
                }
                else if (indexPath.row == 1){
                    
                    if let lastName = inputDict[Headers.lastName] as? String{
                        cell?.textField.text = lastName
//                        inputDict[Headers.lastName] = info?.lastName
                    }
                    else{
                        cell?.textField.text = nil
                    }
                   
                }
            }
            // add functionality
            else{
                print("indexPath: \(indexPath)")
                
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
            
            if (!phoneNumModel.isEmpty){
                cell?.optionLabel.text = phoneNumModel[indexPath.row-1].modelType
                
                
                cell?.cellView.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
                cell?.cellView.tag = indexPath.row
                cell?.numInput.delegate = self
                cell?.numInput.tag = indexPath.row
                
                
                if let number = phoneNumModel[indexPath.row-1].number {
                    
                    cell?.numInput.text = String(number)
                    phoneNumModel[indexPath.row - 1].number = Int64( String(number))
                    inputDict[Headers.phoneNumber] = phoneNumModel
                }
            }
            cell?.numInput.attributedPlaceholder = NSAttributedString(string:Headers.phoneNumber,attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.5)])
            return cell!
        }
        
        
        else if(headerDataSource[indexPath.section].data[0] == Headers.address && indexPath.row > 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: AddressTableViewCell.identifier, for: indexPath) as? AddressTableViewCell
            
            if (!addressModel.isEmpty){
                cell?.optionLabel.text = addressModel[indexPath.row-1].modelType
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
                
                if let doorNo = addressModel[indexPath.row - 1].doorNo{
                    cell?.doorNumTf.text = String(doorNo)
                    addressModel[indexPath.row - 1].doorNo = String(doorNo)
                }
                if let street = addressModel[indexPath.row - 1].Street{
                    cell?.streetTf.text = street
                    addressModel[indexPath.row - 1].Street = street
                }
                if let city = addressModel[indexPath.row - 1].city{
                    cell?.cityTf.text = city
                    addressModel[indexPath.row - 1].city = city
                }
                if let postcode = addressModel[indexPath.row - 1].postcode{
                    cell?.postCodeTf.text = String(postcode)
                    addressModel[indexPath.row - 1].postcode = postcode
                }
                if let state = addressModel[indexPath.row - 1].state{
                    cell?.stateTf.text = state
                    addressModel[indexPath.row - 1].state = state
                }
                if let country = addressModel[indexPath.row - 1].country{
                    cell?.CountryTf.text = country
                    addressModel[indexPath.row - 1].country = country
                }
                inputDict[Headers.address] = addressModel
                
            }
            
            return cell!
        }
        
        else if (headerDataSource[indexPath.section].data[0] == Headers.socialProfile && indexPath.row > 0){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SocialProfileTableViewCell.identifier, for: indexPath) as? SocialProfileTableViewCell
            
            if(!socialProfileModel.isEmpty){
                cell?.optionLabel.text = socialProfileModel[indexPath.row-1].profileType
                
                cell?.cellView.tag = indexPath.row
                cell?.numInput.keyboardType = .emailAddress
                cell?.numInput.delegate = self
                cell?.numInput.tag = indexPath.row
                
                cell?.cellView.addTarget(self, action: #selector(socialProfileOptions), for: .touchUpInside)
                if let link = socialProfileModel[indexPath.row - 1].link{
                    cell?.numInput.text = link
                    socialProfileModel[indexPath.row - 1].link = link
                }
                inputDict[Headers.socialProfile] = socialProfileModel
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
            
            cell.textButton.addTarget(self, action: #selector(tapFavourite), for: .touchUpInside)
            
            if (isFavourite == 0){
                
                cell.textButton.setTitle("Add to favourite", for: .normal)
                cell.textButton.setTitleColor(.label, for: .normal)
            }
            else{
                cell.textButton.setTitle("Added to favourite", for: .normal)
                cell.textButton.setTitleColor(.systemBlue, for: .normal)
            }
            inputDict[Headers.favourite] = isFavourite
            return cell
        }
        else if (headerDataSource[indexPath.section].data[0] == Headers.emergencyContact ){
            let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteAndEmergencyContactTableViewCell.identifier) as! FavouriteAndEmergencyContactTableViewCell
           
            cell.textButton.addTarget(self, action: #selector(tapEmergency), for: .touchUpInside)
            
            if(isEmergencyContact == 0){
                cell.textButton.setTitle("Add to emergency Contact", for: .normal)
                cell.textButton.setTitleColor(.label, for: .normal)
            }
            else{
                cell.textButton.setTitle("Added to emergency contact", for: .normal)
                cell.textButton.setTitleColor(.systemRed, for: .normal)
            }
            inputDict[Headers.emergencyContact] = isFavourite
            return cell
        }
        else if (headerDataSource[indexPath.section].data[0] == Headers.groups && indexPath.row > 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: GroupsTableViewCell.identifier) as! GroupsTableViewCell
            cell.selectionStyle = .blue

            if (selectedGrpIndex.contains(indexPath.row)){

                    cell.leftSideButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                    cell.leftSideButton.tintColor = .systemGreen

            }
            else{
                cell.leftSideButton.setImage(UIImage(systemName: "circle"), for: .normal)
                cell.leftSideButton.tintColor = .systemGreen
            }
            let current = groupNames[indexPath.row - 1]
            let isUserSelected = info?.groups?.contains(current)
            cell.label.text = groupNames[indexPath.row - 1]
            cell.label.textColor = .label
            return cell
        }
        else if (headerDataSource[indexPath.section].data[0] == Headers.workInfo && indexPath.row > 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: AddTableViewCell.identifier, for: indexPath) as! AddTableViewCell
            
            
            cell.textField.tag = indexPath.row - 1
            
            if(!workInfoArray.isEmpty){
                cell.textField.text =  workInfoArray[indexPath.row - 1]
                inputDict[Headers.workInfo] = workInfoArray[indexPath.row - 1]
            }
            cell.textField.attributedPlaceholder = NSAttributedString(string: (headerDataSource[indexPath.section].data[0]),attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.5)])
            
            cell.textField.delegate = self
            
            return cell
            
            
        }
        else if (headerDataSource[indexPath.section].data[0] == Headers.email && indexPath.row > 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: AddTableViewCell.identifier, for: indexPath) as! AddTableViewCell
            cell.textField.tag =  indexPath.row - 1
            
            if indexPath.row-1 < emailArray.count {
                
                cell.textField.text = emailArray[indexPath.row-1]
                inputDict[Headers.email] = emailArray
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
                if(workInfoArray.isEmpty){
                    workInfoArray.append("")
                    
                }
                else{
                    let alertController = UIAlertController(title: nil, message: "Work Info Field should have only one value", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: .default){ _ in
                        
//                                    self.dismiss(animated: true)
                    }
                    
                    alertController.addAction(okAction)
                    
                    present(alertController, animated: true)
                    
                    return
                }
            }
            else if (headerDataSource[indexPath.section].data[0] == Headers.phoneNumber ){
                phoneNumModel.append(PhoneNumberModel(modelType: "mobile"))
                
            }
            else if (headerDataSource[indexPath.section].data[0] == Headers.email){
                emailArray.append("")
                
            }
            else if (headerDataSource[indexPath.section].data[0] == Headers.address ){
                addressModel.append(AddressModel(modelType: "home"))
                
            }
            else if (headerDataSource[indexPath.section].data[0] == Headers.socialProfile ) {
                
                socialProfileModel.append(SocialProfileModel(profileType: "Twitter"))
                
            }
            else if (headerDataSource[indexPath.section].data[0] == Headers.favourite){
                if(isFavourite == 0){
                    isFavourite = 1
                }
                else{
                    isFavourite = 0
                }
                
                
            }
            else if (headerDataSource[indexPath.section].data[0] == Headers.emergencyContact){
                if(isEmergencyContact == 0){
                    isEmergencyContact = 1}
                else{
                    isEmergencyContact = 0
                }
                
                
            }
        }
            else{
                if (headerDataSource[indexPath.section].data[0] == Headers.groups  && indexPath.row > 0){
                    
                    if(selectedGrpIndex.contains(indexPath.row)){
                        for i in 0..<selectedGrpIndex.count{
                            DBHelper.removeContactFromGrp(grpName:groupNames[i],contactId: (inputDict[Headers.contactId] as? Int)!)
//                            groups.remove(at: i)
                            if selectedGrpIndex[i] == indexPath.row{
                                selectedGrpIndex.remove(at: i)
                            }
                        }
                    }

                    else{
                        groups.append(groupNames[indexPath.row - 1])
                        selectedGrpIndex.append(indexPath.row)
                    }
                    
                   
                    
                    
                }
                
            }
            tableView.reloadData()
        
    }
    
    //               else if(headerDataSource[indexPath.section].data[0] != Headers.favourite && headerDataSource[indexPath.section].data[0] != Headers.emergencyContact){
    //
    //                    headerDataSource[indexPath.section].data.append(headerDataSource[indexPath.section].data[0])
    //                    tableView.reloadData()
    //
    //                }
    
    
    
    
    
    
    
    @objc func showOptions(sender:UIButton){
        phoneNumRowIndex = sender.tag
        let phone = PhoneNumOptionsTableView()
        phone.delegate = self
        present(UINavigationController(rootViewController: phone), animated: true)
    }
    @objc func addressOptions(sender:UIButton){
        
        addressRowIndex = sender.tag
        //        print(sender.tag)
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
        if (isFavourite == 0){
            sender.setTitle("Added to favourite", for: .normal)
            sender.setTitleColor(.systemBlue, for: .normal)
            isFavourite = 1
        }
        else{
            sender.setTitle("Add to favourite", for: .normal)
            sender.setTitleColor(.label, for: .normal)
//            sender.setImage(UIImage(systemName: "star"), for: .normal)
            isFavourite = 0
        }
        
        
        
    }
    @objc func tapEmergency(sender:UIButton){
        
        if (isEmergencyContact == 0){
            sender.setTitle("Added to emergency contact", for: .normal)
            sender.setTitleColor(.systemRed, for: .normal)
//            sender.setImage(UIImage(systemName: "staroflife.fill"), for: .normal)
            isEmergencyContact = 1
        }
        else{
            sender.setTitle("Add to emergency contact", for: .normal)
            sender.setTitleColor(.label, for: .normal)
//            sender.setImage(nil, for: .normal)
//            sender.setImage(UIImage(systemName: "staroflife"), for: .normal)
            isEmergencyContact = 0
        }
        sender.tintColor = .systemRed
        
        
    }
    @objc func cancelButton(){
        print("cancel ==> \(inputDict)")
        if(isEdited){
            let alertController = UIAlertController(title: nil, message: "Are you sure you want to discard this new contact", preferredStyle: .actionSheet)
            
        let discardAction = UIAlertAction(title: "Discard changes", style: .destructive){ _ in
                
                        self.dismiss(animated: true)
            }
            let editingAction = UIAlertAction(title: "Keep Editing", style: .cancel){ _ in
                    
    //                        self.dismiss(animated: true)
                }
            alertController.addAction(discardAction)
            alertController.addAction(editingAction)
            
            present(alertController, animated: true)
            
            return
        }
        if (info != nil){
            navigationController?.popViewController(animated: true)
            dismiss(animated: true)
        }
        dismiss(animated: true)
    }
    
    @objc func DoneButton(){
        view.endEditing(true)
        print("inputDict in done button : \(inputDict)")
        //edit functionality
        if (info != nil){
            let profimg = inputDict[Headers.profileImage] as? UIImage
            var addArr:[AddressModel] = []
            var phoneNumArr:[PhoneNumberModel] = []
            for i in inputDict[Headers.address] as! [AddressModel]{
                if i.doorNo != nil && i.Street != nil && i.city != nil && i.postcode != nil && i.state != nil && i.country != nil {
                    
                    addArr.append(i)
                }
            }
            if workInfoArray.isEmpty{
                inputDict[Headers.workInfo] = nil
            }
            else{
                inputDict[Headers.workInfo] = workInfoArray
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
            }
            var socprofArr:[SocialProfileModel] = []
            for i in inputDict[Headers.socialProfile] as! [SocialProfileModel]{
                if i.link != nil {
                    socprofArr.append(i)
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
            
            let newContact = Contacts(contactId: id!,profileImage: profimg?.pngData(), firstName: inputDict[Headers.firstName] as! String,lastName: inputDict[Headers.lastName] as? String,workInfo:  inputDict[Headers.workInfo] as? String,phoneNumber: phoneNumArr,email: inputDict[Headers.email] as? [String],address: inputDict[Headers.address] as? [AddressModel],socialProfile: inputDict[Headers.socialProfile] as?[SocialProfileModel],favourite:isFavourite,emergencyContact: isEmergencyContact,notes: inputDict[Headers.notes] as? String ,groups: groups)
            
            DBHelper.updateContact(contact: newContact)
            allContactsVc?.refreshDataSource()
            allContactsVc?.tableView.reloadData()
            editDelegate?.getUpdatedContact(newContact: newContact)
            let profVc = ProfilePageViewController(contact: newContact)
            profVc.titleDelegate = self
            navigationController?.popViewController(animated: true)
            
            //            navigationController?.pushViewController(ProfilePageViewController(contact: newContact), animated: true)
            
        }
        // add functionality
        else{

            guard let firstName = inputDict[Headers.firstName] as? String
                else{
                    let alertController = UIAlertController(title: nil, message: "First Name Field is Mandatory", preferredStyle: .alert)
                    
                let okAction = UIAlertAction(title: "OK", style: .cancel){ _ in
                        return
//                        self.dismiss(animated: true)
                    }
                    
                    alertController.addAction(okAction)
                    
                    present(alertController, animated: true)
                    
                    return
                
                }
            
            guard let _ = inputDict[Headers.phoneNumber] else{
                let alertController = UIAlertController(title: nil, message: "Mobile Number Field is Mandatory", preferredStyle: .alert)
                
            let okAction = UIAlertAction(title: "OK", style: .cancel){ _ in
                    return
//                        self.dismiss(animated: true)
                }
                
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
                id = myInt
                print("input dict in add : \(inputDict)")
            
                let newContact = Contacts(
                    contactId: id!,
                    profileImage: image?.pngData(),
                    firstName:firstName,
                    lastName: inputDict[Headers.lastName] as? String,
                    workInfo:  inputDict[Headers.workInfo] as? String,
                    phoneNumber: (inputDict[Headers.phoneNumber]) as! [PhoneNumberModel],
                    email: (inputDict[Headers.email]) as? [String],
                    address: (inputDict[Headers.address]) as? [AddressModel],
                    socialProfile: (inputDict[Headers.socialProfile]) as? [SocialProfileModel],
                    favourite:isFavourite,
                    emergencyContact: isEmergencyContact,
                    notes: (inputDict[Headers.notes]) as? String  ,
                    groups: groups)
                
                DBHelper.assignDb(contactList: newContact)
                //        tabvc?.refreshFavData()
                allContactsVc?.refreshDataSource()
                allContactsVc?.tableView.reloadData()
                
//                addtoLocalGrpDataSource(grpName:groups,contact:newContact)
                
                dismiss(animated: true)
            }
            
        }
        
//        func addtoLocalGrpDataSource(grpName:[String],contact:Contacts){
//            for i in grpName{
//                if grpData.isEmpty {
//                    grpData.append(GroupModel(groupName: i, data: [SectionContent(sectionName: String(contact.firstName.first!), rows: [contact])]))
//                }
//                else{
//                    var bool = false
//                    for j in 0..<grpData.count{
//                        if (grpData[j].groupName == i){
//                            for k in 0..<grpData[j].data.count{
//                                if(grpData[j].data[k].sectionName == String(contact.firstName.first!)){
//                                    grpData[j].data[k].rows.append(contact)
//                                    bool = true
//                                }
//                            }
//                            if (!bool){
//
//                                grpData.append(GroupModel(groupName: i, data: [SectionContent(sectionName: String(contact.firstName.first!), rows: [contact])]))
//                            }
//                        }
//                        tableView.reloadData()
//                    }
//                }
//            }
//        }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            view.endEditing(true)
        }
    func getImage(images: UIImage) {
        image = images
        photoLabel.image = image
        inputDict[Headers.profileImage] = image
        photoLabel.layer.cornerRadius = photoLabel.frame.size.width / 2
        photoLabel.layer.masksToBounds = true
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //        print(info)
        if let images = info[.editedImage] as? UIImage{
            photoLabel.image = images
            inputDict[Headers.profileImage] = images
            photoLabel.layer.cornerRadius = 75
            photoLabel.layer.masksToBounds = true
            image = images
        }
        
        
        picker.dismiss(animated: true)
        addPhotoButton.setTitle("Edit Photo", for: .normal)
    }
        
    }
//    var textFieldValues:[Any] = []
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//            for cell in tableView.visibleCells {
//                guard let _ = tableView.indexPath(for: cell),
//                      let textField = cell.contentView.subviews.first(where: { $0 is UITextField }) as? UITextField,
//                      let _ = textField.text else {
//                    continue
//                }
//                print(inputDict)
//                switch textField.attributedPlaceholder?.string{
//
//                case Headers.firstName:
//                    if(inputDict[Headers.firstName]==nil){
//                        if let firstName = textField.text{
//                            if firstName != ""{
//                                inputDict[Headers.firstName] = firstName}
//                            else{
//                                inputDict[Headers.firstName] = nil
//                            }
//                        }
//                        else{
//                            inputDict[Headers.firstName] = nil
//                        }
//                    }
//
//                case Headers.lastName:
//                    if(inputDict[Headers.lastName]==nil){
//                        if let lastName = textField.text {
//
//                            if lastName != ""{
//                                inputDict[Headers.lastName] = lastName
//                            }
//                            else{
//                                inputDict[Headers.lastName] = nil
//                            }
//                        }
//                        else{
//                            inputDict[Headers.lastName] = nil
//                        }
//                    }
//                case Headers.workInfo:
//                    if(inputDict[Headers.workInfo]==nil){
//                        if let workInfo = textField.text{
//                            workInfoArray[textField.tag ] = workInfo
//
//                            inputDict[Headers.workInfo] = workInfoArray[0]}
//                        else{
//                            inputDict[Headers.workInfo] = nil
//                        }
//                    }
//                case Headers.email:
//                    if(inputDict[Headers.email]==nil){
//                        if let email = textField.text{
//
//                            emailArray[textField.tag ] = (email)
//                            inputDict[Headers.email] = emailArray}
//                        else{
//                            inputDict[Headers.email] = nil
//                        }
//                    }
//                case "phone":
//
//                    if(inputDict["phone"]==nil){
//                        if let phoneNumber = textField.text {
//                            phoneNumModel[textField.tag - 1 ].number = Int64(phoneNumber)
//                            inputDict["phone"] = phoneNumModel
//                            print(phoneNumModel)
//                        }
//                        else{
//                            inputDict["phone"] = nil
//                        }
//                    }
//                case "Door no." :
//                    if(inputDict[Headers.address]==nil){
//                        if let doorNo = textField.text{
//                            addressModel[textField.tag - 1].doorNo = doorNo
//                        }
//                        else{
//                            addressModel[textField.tag - 1].doorNo = nil
//                        }
//                    }
//
//
//                case "street":
//                    if(inputDict[Headers.address]==nil){
//                        if let street = textField.text {
//                            addressModel[textField.tag - 1].Street = street
//                        }
//                        else{
//                            addressModel[textField.tag - 1].Street = nil
//                        }
//                    }
//                case "City":
//                    if(inputDict[Headers.address]==nil){
//                        if let city = textField.text{
//                            addressModel[textField.tag - 1].city = city
//                        }
//                        else{
//                            addressModel[textField.tag - 1].city = nil
//                        }
//                    }
//                case "PostCode":
//                    if(inputDict[Headers.address]==nil){
//                        if let postcode = textField.text{
//                            addressModel[textField.tag - 1].postcode = postcode}
//                        else{
//                            addressModel[textField.tag - 1].postcode = nil
//                        }
//                    }
//                case "state":
//                    if(inputDict[Headers.address]==nil){
//                        if let state = textField.text{
//                            addressModel[textField.tag - 1].state = state
//                        }
//                        else{
//                            addressModel[textField.tag - 1].state = nil
//                        }
//                    }
//                case "Country":
//                    if(inputDict[Headers.address]==nil){
//                        if let country = textField.text{
//                            addressModel[textField.tag - 1].country = country
//                        }
//                        else{
//                            addressModel[textField.tag - 1].country = nil
//                        }
//                        inputDict[Headers.address] = addressModel
//                    }
//
//                case Headers.socialProfile:
//                    if(inputDict[Headers.address]==nil){
//                        if let socialProfile = textField.text{
//                            socialProfileModel[textField.tag - 1].link = socialProfile
//
//                        }
//                        else{
//                            socialProfileModel[textField.tag - 1].link = nil
//                        }
//                        inputDict[Headers.socialProfile] = socialProfileModel}
//
//                default:
//                   return
//
//                }
//
//            }
//
//
//            print(inputDict)
//        }
//
    



extension InfoSheetViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isEdited = true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
            switch textField.attributedPlaceholder?.string{
                
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
                    workInfoArray[textField.tag ] = workInfo
                    
                    inputDict[Headers.workInfo] = workInfoArray[0]
                    
                }

                
                
            case Headers.email:
                if let email = textField.text{
                    if email != ""{
                        emailArray[textField.tag ] = (email)
                        inputDict[Headers.email] = emailArray}
                }

                
            case Headers.phoneNumber:
                if let phoneNumber = textField.text {
                   
                    let result = String(phoneNumber).range(
                        of: #"^\d{1,10}$"#,
                        options: .regularExpression
                    )
                    if(result != nil){
                        phoneNumModel[textField.tag - 1 ].number = Int64(phoneNumber)
                        inputDict[Headers.phoneNumber] = phoneNumModel

                    }
                    else{
                        let alertController = UIAlertController(title: "Invalid Phone Number", message: "Phone number should not contain alphabets!", preferredStyle: .alert)
                        
                    let okAction = UIAlertAction(title: "OK", style: .cancel){ _ in
                            
    //                        self.dismiss(animated: true)
                        }
                        
                        alertController.addAction(okAction)
                        
                        present(alertController, animated: true)
                        
                        return
                     
                    }
                   
                }

            case "Door no." :
                if let doorNo = textField.text{
                    addressModel[textField.tag - 1].doorNo = doorNo
                    inputDict[Headers.address] = addressModel
                }

                
                
            case "Street":
                if let street = textField.text {
                    addressModel[textField.tag - 1].Street = street
                    inputDict[Headers.address] = addressModel
                }
                
            case "City":
                if let city = textField.text{
                    addressModel[textField.tag - 1].city = city
                    inputDict[Headers.address] = addressModel
                }

            case "PostCode":
                if let postcode = textField.text{
                    addressModel[textField.tag - 1].postcode = postcode
                    inputDict[Headers.address] = addressModel
                }

            case "State":
                if let state = textField.text{
                    addressModel[textField.tag - 1].state = state
                    inputDict[Headers.address] = addressModel
                }

            case "Country":
                if let country = textField.text{
                    addressModel[textField.tag - 1].country = country
                    inputDict[Headers.address] = addressModel
                    
                }

              
               
                
                
                
            case Headers.socialProfile:
                if let socialProfile = textField.text{
                    socialProfileModel[textField.tag - 1].link = socialProfile
                    
                }
                else{
                    socialProfileModel[textField.tag - 1].link = nil
                }
                inputDict[Headers.socialProfile] = socialProfileModel
                
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
        if textView.textColor == UIColor.gray {
            textView.text = ""
            textView.textColor = UIColor.label
        }
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
            
            phoneNumModel[phoneNumRowIndex! - 1].modelType = option
            
            
        }
        else if type == Headers.address{
            
            addressModel[addressRowIndex! - 1].modelType = option
            
        }
        
        else if type == Headers.socialProfile{
            
            socialProfileModel[socialProfileRowIndex! - 1].profileType = option
        }
        tableView.reloadData()
        
        
    }
}
