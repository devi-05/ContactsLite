//  InfoSheetViewController.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 31/03/23.
//

import UIKit


class InfoSheetViewController: UITableViewController, UINavigationControllerDelegate {
    
    lazy var grpData:[GroupModel] = []
    var editDelegate:editDelegate?
    var selectedGrpIndex:[Int] = []
    weak var allContactsVc:AllContactsVc?
    
    var info:Contacts?
    var inputDict:[String:Any] = [:]
    
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
    
    
    
    
    //    var preferredPhoneNumOption:String="mobile"
    //
    //    var preferredAddressOption:String="home"
    //
    //    var preferredSocialProfileOption:String="Twitter"
    
    
    
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
        inputDict = [:]
        lazy  var fetchedData = DBHelper.fetchData()
        lazy var dbContactList = Helper.decodeToContact(list: fetchedData)
        lazy var localDataSource = Helper.extractNamesFromFetchedData(lists: Helper.sort(data: dbContactList))
        lazy var grpNames = DBHelper.fetchGrpNames(colName: "GROUP_NAME")
        lazy var groupNames:[String] = Helper.getGrpNames(grpName: grpNames)
        
        grpData = Helper.getGroupsData(locDS:localDataSource , grpName: groupNames)
        
        
        
        tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("did appear")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Contact"
        
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
            //Edit functionality
            id = info?.contactId
            if(info?.profileImage != nil){
                image = UIImage(data: (info?.profileImage)!)
                photoLabel.image = image
                addPhotoButton.setTitle("Edit Photo", for: .normal)
                inputDict["Profile Image"] = image
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
                groups = grps
                inputDict[Headers.groups] = groups
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
                return (groups.count)+1
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
                    return grpData.count
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
                groups.append(grpData[indexPath.row].groupName)
                
            }
        }
        else if editingStyle == .delete {
            if (headerDataSource[indexPath.section].data[0] == Headers.workInfo ){
                workInfoArray.remove(at: indexPath.row - 1)
            }
            else if (headerDataSource[indexPath.section].data[0] == Headers.phoneNumber ){
                phoneNumModel.remove(at: indexPath.row - 1)
            }
            else if (headerDataSource[indexPath.section].data[0] == Headers.email ){
                emailArray.remove(at: indexPath.row - 1)
            }
            else if (headerDataSource[indexPath.section].data[0] == Headers.address ){
                if (!addressModel.isEmpty){
                    addressModel.remove(at: indexPath.row - 1)
                }
            }
            else if (headerDataSource[indexPath.section].data[0] == Headers.socialProfile){
                if (!socialProfileModel.isEmpty){
                    socialProfileModel.remove(at: indexPath.row - 1)
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
                    cell?.textField.text = (info?.firstName)
                    inputDict[Headers.firstName] = info?.firstName
                    
                }
                else if (indexPath.row == 1){
                    
                    if let lastName = info?.lastName{
                        cell?.textField.text = lastName
                        inputDict[Headers.lastName] = info?.lastName
                    }
                }
            }
            // add functionality
            else{
                print("indexPath: \(indexPath)")
                print(indexPath.row)
                if inputDict[Headers.firstName] != nil && indexPath.row == 0 {
                    if let firstName = inputDict[Headers.firstName]{
                        cell?.textField.text = firstName as? String
                    }
                }
                
                else if inputDict[Headers.lastName] != nil && indexPath.row == 1{
                    if let lastName = inputDict[Headers.lastName]{
                        cell?.textField.text = lastName as? String
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
                    inputDict["phone"] = phoneNumModel
                }
            }
            cell?.numInput.attributedPlaceholder = NSAttributedString(string:"phone",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.5)])
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
            if info != nil{
                if let notes = info?.notes{
                    cell.textView.text = notes
                    
                    inputDict[Headers.notes] = info?.notes
                }
                else{
                    cell.textView.text = Headers.notes
                }
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
                
            }
            else{
                cell.textButton.setTitle("Added to favourite", for: .normal)
            }
            inputDict[Headers.favourite] = isFavourite
            return cell
        }
        else if (headerDataSource[indexPath.section].data[0] == Headers.emergencyContact ){
            let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteAndEmergencyContactTableViewCell.identifier) as! FavouriteAndEmergencyContactTableViewCell
           
            cell.textButton.addTarget(self, action: #selector(tapEmergency), for: .touchUpInside)
            
            if(isEmergencyContact == 0){
                cell.textButton.setTitle("Add to emergency Contact", for: .normal)
                
            }
            else{
                cell.textButton.setTitle("Added to emergency contact", for: .normal)
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
            cell.label.text = grpData[indexPath.row].groupName
            cell.label.textColor = .label
            return cell
        }
        else if (headerDataSource[indexPath.section].data[0] == Headers.workInfo && indexPath.row > 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: AddTableViewCell.identifier, for: indexPath) as! AddTableViewCell
            
            
            cell.textField.tag = indexPath.row - 1
            
            if(!workInfoArray.isEmpty){
                cell.textField.text =  workInfoArray[indexPath.row - 1]
                inputDict[Headers.workInfo] = workInfoArray
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
        
        if (headerDataSource[indexPath.section].data[0] == Headers.workInfo){
            if(workInfoArray.isEmpty){
                workInfoArray.append("")
                
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
        
        else{
            if (headerDataSource[indexPath.section].data[0] == Headers.groups  && indexPath.row > 0){
                if(selectedGrpIndex.contains(indexPath.row)){
                    for i in 0..<selectedGrpIndex.count{
                        if selectedGrpIndex[i] == indexPath.row{
                            selectedGrpIndex.remove(at: i)
                        }
                    }
                }
                
                else{
                    selectedGrpIndex.append(indexPath.row)
                }
                
                groups.append(grpData[indexPath.row].groupName)
                
                
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
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
            isFavourite = 1
        }
        else{
            sender.setTitle("Add to favourite", for: .normal)
            sender.setImage(nil, for: .normal)
//            sender.setImage(UIImage(systemName: "star"), for: .normal)
            isFavourite = 0
        }
        sender.tintColor = .systemBlue
        
        
    }
    @objc func tapEmergency(sender:UIButton){
        
        if (isEmergencyContact == 0){
            sender.setTitle("Added to emergency contact", for: .normal)
            sender.setImage(UIImage(systemName: "staroflife.fill"), for: .normal)
            isEmergencyContact = 1
        }
        else{
            sender.setTitle("Add to emergency contact", for: .normal)
            sender.setImage(nil, for: .normal)
//            sender.setImage(UIImage(systemName: "staroflife"), for: .normal)
            isEmergencyContact = 0
        }
        sender.tintColor = .systemRed
        
        
    }
    @objc func cancelButton(){
        if (info != nil){
            navigationController?.popViewController(animated: true)
            
        }
        dismiss(animated: true)
    }
    
    @objc func DoneButton(){
//        view.endEditing(true)
        //edit functionality
        if (info != nil){
            
//            viewWillDisappear(true)
            print(inputDict)
            let newContact = Contacts(contactId: id!,profileImage: image?.pngData(), firstName: inputDict[Headers.firstName] as! String,lastName: inputDict[Headers.lastName] as? String,workInfo:  inputDict[Headers.workInfo] as? String,phoneNumber: ((inputDict["phone"]) as? [PhoneNumberModel])!,email: (inputDict[Headers.email]) as? [String],address: (inputDict[Headers.address]) as? [AddressModel],socialProfile: (inputDict[Headers.socialProfile]) as? [SocialProfileModel],favourite:isFavourite,emergencyContact: isEmergencyContact,notes: inputDict[Headers.notes] as? String ,groups: groups)
            DBHelper.updateContact(contact: newContact)
            allContactsVc?.refreshDataSource()
            allContactsVc?.tableView.reloadData()
            editDelegate?.getUpdatedContact(newContact: newContact)
            navigationController?.popViewController(animated: true)
            //            navigationController?.pushViewController(ProfilePageViewController(contact: newContact), animated: true)
            
        }
        // add functionality
        else{
            if let firstName = inputDict[Headers.firstName] as? String{
                guard (!firstName.isEmpty),
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
                guard let firstName = inputDict[Headers.firstName] as? String else{
                    let alertController = UIAlertController(title: nil, message: "Error in First Name", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default){ _ in
                        
                        self.dismiss(animated: true)
                    }
                    
                    alertController.addAction(okAction)
                    
                    present(alertController, animated: true)
                    
                    return
                }
                let newContact = Contacts(
                    contactId: id!,
                    profileImage: image?.pngData(),
                    firstName: firstName,
                    lastName: inputDict[Headers.lastName] as? String,
                    workInfo:  inputDict[Headers.workInfo] as? String,
                    phoneNumber: (inputDict["phone"]) as! [PhoneNumberModel],
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
                
                addtoLocalGrpDataSource(grpName:groups,contact:newContact)
                
                dismiss(animated: true)
            }
            
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
        func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            view.endEditing(true)
        }
        
    }
//    var textFieldValues:[Any] = []
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

            for cell in tableView.visibleCells {
                guard let _ = tableView.indexPath(for: cell),
                      let textField = cell.contentView.subviews.first(where: { $0 is UITextField }) as? UITextField,
                      let _ = textField.text else {
                    continue
                }
                print(inputDict)
                switch textField.attributedPlaceholder?.string{

                case Headers.firstName:
                    if(inputDict[Headers.firstName]==nil){
                        if let firstName = textField.text{
                            if firstName != ""{
                                inputDict[Headers.firstName] = firstName}
                            else{
                                inputDict[Headers.firstName] = nil
                            }
                        }
                        else{
                            inputDict[Headers.firstName] = nil
                        }
                    }

                case Headers.lastName:
                    if(inputDict[Headers.lastName]==nil){
                        if let lastName = textField.text {

                            if lastName != ""{
                                inputDict[Headers.lastName] = lastName
                            }
                            else{
                                inputDict[Headers.lastName] = nil
                            }
                        }
                        else{
                            inputDict[Headers.lastName] = nil
                        }
                    }
                case Headers.workInfo:
                    if(inputDict[Headers.workInfo]==nil){
                        if let workInfo = textField.text{
                            workInfoArray[textField.tag ] = workInfo

                            inputDict[Headers.workInfo] = workInfoArray[0]}
                        else{
                            inputDict[Headers.workInfo] = nil
                        }
                    }
                case Headers.email:
                    if(inputDict[Headers.email]==nil){
                        if let email = textField.text{

                            emailArray[textField.tag ] = (email)
                            inputDict[Headers.email] = emailArray}
                        else{
                            inputDict[Headers.email] = nil
                        }
                    }
                case "phone":

                    if(inputDict["phone"]==nil){
                        if let phoneNumber = textField.text {
                            phoneNumModel[textField.tag - 1 ].number = Int64(phoneNumber)
                            inputDict["phone"] = phoneNumModel
                            print(phoneNumModel)
                        }
                        else{
                            inputDict["phone"] = nil
                        }
                    }
                case "Door no." :
                    if(inputDict[Headers.address]==nil){
                        if let doorNo = textField.text{
                            addressModel[textField.tag - 1].doorNo = doorNo
                        }
                        else{
                            addressModel[textField.tag - 1].doorNo = nil
                        }
                    }


                case "street":
                    if(inputDict[Headers.address]==nil){
                        if let street = textField.text {
                            addressModel[textField.tag - 1].Street = street
                        }
                        else{
                            addressModel[textField.tag - 1].Street = nil
                        }
                    }
                case "City":
                    if(inputDict[Headers.address]==nil){
                        if let city = textField.text{
                            addressModel[textField.tag - 1].city = city
                        }
                        else{
                            addressModel[textField.tag - 1].city = nil
                        }
                    }
                case "PostCode":
                    if(inputDict[Headers.address]==nil){
                        if let postcode = textField.text{
                            addressModel[textField.tag - 1].postcode = postcode}
                        else{
                            addressModel[textField.tag - 1].postcode = nil
                        }
                    }
                case "state":
                    if(inputDict[Headers.address]==nil){
                        if let state = textField.text{
                            addressModel[textField.tag - 1].state = state
                        }
                        else{
                            addressModel[textField.tag - 1].state = nil
                        }
                    }
                case "Country":
                    if(inputDict[Headers.address]==nil){
                        if let country = textField.text{
                            addressModel[textField.tag - 1].country = country
                        }
                        else{
                            addressModel[textField.tag - 1].country = nil
                        }
                        inputDict[Headers.address] = addressModel
                    }

                case Headers.socialProfile:
                    if(inputDict[Headers.address]==nil){
                        if let socialProfile = textField.text{
                            socialProfileModel[textField.tag - 1].link = socialProfile

                        }
                        else{
                            socialProfileModel[textField.tag - 1].link = nil
                        }
                        inputDict[Headers.socialProfile] = socialProfileModel}

                default:
                   return

                }

            }
            // Add the text value to an array for later use.
//            textFieldValues.append(text)


            // Do something with the array of text field values before the view is dismissed.
           
            print(inputDict)
        }
   
    }



extension InfoSheetViewController:UITextFieldDelegate {
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
                else{
                    inputDict[Headers.firstName] = nil
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
                else{
                    inputDict[Headers.lastName] = nil
                }
                
            case Headers.workInfo:
                
                if let workInfo = textField.text{
                    workInfoArray[textField.tag ] = workInfo
                    
                    inputDict[Headers.workInfo] = workInfoArray[0]}
                else{
                    inputDict[Headers.workInfo] = nil
                }
                
                
            case Headers.email:
                if let email = textField.text{
                    
                    emailArray[textField.tag ] = (email)
                    inputDict[Headers.email] = emailArray}
                else{
                    inputDict[Headers.email] = nil
                }
                
            case "phone":
                if let phoneNumber = textField.text {
                    phoneNumModel[textField.tag - 1 ].number = Int64(phoneNumber)
                    inputDict["phone"] = phoneNumModel
                }
                else{
                    inputDict["phone"] = nil
                }
            case "Door no." :
                if let doorNo = textField.text{
                    addressModel[textField.tag - 1].doorNo = doorNo
                }
                else{
                    addressModel[textField.tag - 1].doorNo = nil
                }
                
                
            case "street":
                if let street = textField.text {
                    addressModel[textField.tag - 1].Street = street
                }
                else{
                    addressModel[textField.tag - 1].Street = nil
                }
            case "City":
                if let city = textField.text{
                    addressModel[textField.tag - 1].city = city
                }
                else{
                    addressModel[textField.tag - 1].city = nil
                }
            case "PostCode":
                if let postcode = textField.text{
                    addressModel[textField.tag - 1].postcode = postcode}
                else{
                    addressModel[textField.tag - 1].postcode = nil
                }
            case "state":
                if let state = textField.text{
                    addressModel[textField.tag - 1].state = state
                }
                else{
                    addressModel[textField.tag - 1].state = nil
                }
            case "Country":
                if let country = textField.text{
                    addressModel[textField.tag - 1].country = country
                }
                else{
                    addressModel[textField.tag - 1].country = nil
                }
                inputDict[Headers.address] = addressModel
                
                
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

extension InfoSheetViewController:UIImagePickerControllerDelegate{
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
}

extension InfoSheetViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray {
            textView.text = ""
            textView.textColor = UIColor.label
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = Headers.notes
            textView.textColor = UIColor.gray
            textView.resignFirstResponder()
        }
        else{
            if(inputDict[Headers.notes] != nil){
                if let notes = textView.text{
                    inputDict[Headers.notes] = notes
                }
                else{
                    inputDict[Headers.notes] = nil
                }
            }
        }
    }
    
}
        
    
//    func textViewDidEndEditing(_ textView: UITextView) {
//
//
//        if textView.text == "" {
//            textView.text = Headers.notes
//            textView.textColor = UIColor.gray
//        }
//        textView.resignFirstResponder()
//    }
//}
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
extension InfoSheetViewController:ImageDelegate{
    func getImage(images: UIImage) {
        image = images
        photoLabel.image = image
        photoLabel.layer.cornerRadius = photoLabel.frame.size.width / 2
        photoLabel.layer.masksToBounds = true
        
    }
}
