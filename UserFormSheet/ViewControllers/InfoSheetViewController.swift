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
//    var isAddTapped:Bool = false
    
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
        DataSource(data: ["First Name","Last Name"]),
        DataSource(data: ["Work Info"]),
        DataSource(data: ["PhoneNumber"]),
        DataSource(data: ["Email"]),
        DataSource(data: ["Address"]),
        DataSource(data: ["Social Profile"]),
        DataSource(data: ["Notes"]),
        DataSource(data: ["Groups"]),
        DataSource(data: ["Favourites"]),
        DataSource(data: ["Emergency Contact"])]
    
    
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
            
            addressModel[addressRowIndex! - 1].modelType = option
            
        }
        
        else if type == "Social Profile"{
            
            socialProfileModel[socialProfileRowIndex! - 1].profileType = option
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
//                photoLabel.layer.cornerRadius = photoLabel.frame.size.width / 2
//                photoLabel.layer.masksToBounds = true
                addPhotoButton.setTitle("Edit Photo", for: .normal)
                
            }
            
            
//            firstName = info!.firstName
//            lastName = info?.lastName
//            workInfo = info?.workInfo
//            phoneNumModel = info!.phoneNumber
//            emailArray = (info?.Email)!
//            addressModel = (info?.address)!
//            socialProfileModel = (info?.socialprofile)!
//            notes = info?.notes
//            isFavourite = (info?.favourite)!
//            isEmergencyContact = (info?.emergencyContact)!
            
            return
        }
    }
    
    @objc func cancelButton(){
        if (info != nil){
            navigationController?.popViewController(animated: true)
            
        }
        dismiss(animated: true)
    }
    
    @objc func DoneButton(){
        view.endEditing(true)
        if (info != nil){
            navigationController?.popViewController(animated: true)
            let newContact = Contacts(contactId: id!,profileImage: image?.pngData(), firstName: inputDict["First Name"]! as! String,lastName: inputDict["Last Name"] as? String,workInfo:  inputDict["Work Info"] as? String,phoneNumber: (inputDict["phone"]) as! [PhoneNumberModel],email: (inputDict["Email"]) as? [String],address: (inputDict["Address"]) as? [AddressModel],socialProfile: (inputDict["Social Profile"]) as? [SocialProfileModel],favourite:isFavourite,emergencyContact: isEmergencyContact,notes: String(describing:(inputDict["Notes"]))  ,groups: groups)
            print(newContact)
        }
        
        guard !String(describing:inputDict["First Name"]).isEmpty,
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
        guard let firstName = inputDict["First Name"] as? String else{
            let alertController = UIAlertController(title: nil, message: "Error in First Name", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default){ _ in
                print("aery")
                self.dismiss(animated: true)
            }

            alertController.addAction(okAction)
//            UIApplication.shared.windows.first?.rootViewController?.presentedViewController?.present(alertController, animated: true)
            present(alertController, animated: true)
            
            return
        }
        let newContact = Contacts(
            contactId: id!,
            profileImage: image?.pngData(),
            firstName: firstName,
            lastName: inputDict["Last Name"] as? String,
            workInfo:  inputDict["Work Info"] as? String,
            phoneNumber: (inputDict["phone"]) as! [PhoneNumberModel],
            email: (inputDict["Email"]) as? [String],
            address: (inputDict["Address"]) as? [AddressModel],
            socialProfile: (inputDict["Social Profile"]) as? [SocialProfileModel],
            favourite:isFavourite,
            emergencyContact: isEmergencyContact,
            notes: (inputDict["Notes"]) as? String  ,
            groups: groups)
       
        DBHelper.assignDb(contactList: newContact)
        //        tabvc?.refreshFavData()
        allContactsVc?.refreshDataSource()
        allContactsVc?.tableView.reloadData()
        
        addtoLocalGrpDataSource(grpName:groups,contact:newContact)
        
        dismiss(animated: true)
        
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
    
    //    @objc func addPhoto() {
    //        let imgPicker = ImagePickerViewController()
    //        imgPicker.delegate = self
    //        present(UINavigationController(rootViewController: imgPicker), animated: true)
    //        print("adding photo")
    //    }
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
        if(info != nil){
            
            if  headerDataSource[section].data[0] == "Work Info"{
                return info?.workInfo != nil ? 2 : 1
            }
            else if headerDataSource[section].data[0] == "Email"{
                return info?.email != nil ? 2 : 1
            }
            else if headerDataSource[section].data[0] == "PhoneNumber" {
                return (info?.phoneNumber.count)!+1
            }
            else if headerDataSource[section].data[0] == "Address"{
                return (info?.address?.count)!+1
            }
            else if headerDataSource[section].data[0] == "Social Profile"{
                return (info?.socialProfile?.count)!+1
            }
            else{
                return 1
            }
        }
        else{
            if(section == 0){
                return 2
            }
            else{
                switch headerDataSource[section].data[0]{
                case "Work Info":
                    return  (workInfoArray.count+1)
                case "PhoneNumber":
                    return  (phoneNumModel.count+1)
                case "Email":
                    return  (emailArray.count+1)
                case "Address":
                    return (addressModel.count+1)
                case "Social Profile":
                    return (socialProfileModel.count+1)
                case "Favourites":
                    return 1
                case "Emergency Contact":
                    return 1
                case "Notes":
                    return 1
                default:
                    return grpData.count
                }
            }
        }
        
//        return section == 0 ? 2: ( section == 7 ? grpData.count:headerDataSource[section].data.count)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
       
        if headerDataSource[indexPath.section].data[0] == "Favourites"  || headerDataSource[indexPath.section].data[0] == "Emergency Contact"  || headerDataSource[indexPath.section].data[0] == "Notes"  || (headerDataSource[indexPath.section].data[0] == "Groups"  && indexPath.row == 0){
            
            return UITableViewCell.EditingStyle.none
        }
        
        
        if indexPath.section > 0 && indexPath.row > 0 && headerDataSource[indexPath.section].data[0] != "Groups"  {
            return UITableViewCell.EditingStyle.delete
        }
        
        if ( indexPath.section > 0 || (headerDataSource[indexPath.section].data[0] == "Groups"  && indexPath.row > 0)){
            return  UITableViewCell.EditingStyle.insert
        }
        
        else{
            return UITableViewCell.EditingStyle.none
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .insert{
            
            if(headerDataSource[indexPath.section].data[0] != "Groups" ){
                if (headerDataSource[indexPath.section].data[0] == "Work Info"){
                    if(workInfoArray.isEmpty){
                        workInfoArray.append("")
                    }
                }
                else if (headerDataSource[indexPath.section].data[0] == "PhoneNumber" ){
                    phoneNumModel.append(PhoneNumberModel(modelType: "mobile"))
                }
                else if (headerDataSource[indexPath.section].data[0] == "Address" ){
                    addressModel.append(AddressModel(modelType: "home"))
                    
                }
                else if (headerDataSource[indexPath.section].data[0] == "Social Profile" ) {                    socialProfileModel.append(SocialProfileModel(profileType: "Twitter"))
                }
                else if (headerDataSource[indexPath.section].data[0] == "Email" ){
                    
                    emailArray.append("")
                }
                
                tableView.reloadData()

            }
            else{
                groups.append(grpData[indexPath.row].groupName)
                
            }
        }
        else if editingStyle == .delete {
            if (headerDataSource[indexPath.section].data[0] == "PhoneNumber" ){
                phoneNumModel.remove(at: indexPath.row - 1)
            }
            else if (headerDataSource[indexPath.section].data[0] == "Address" ){
                if (!addressModel.isEmpty){
                    addressModel.remove(at: indexPath.row - 1)
                }
            }
            else if (headerDataSource[indexPath.section].data[0] == "Email" ){
                emailArray.remove(at: indexPath.row - 1)
            }
            else if (headerDataSource[indexPath.section].data[indexPath.row - 1] == "Work Info" ){
                workInfoArray.remove(at: indexPath.row - 1)
            }
            
//            headerDataSource[indexPath.section].data.remove(at: indexPath.row)
            

            tableView.reloadData()
        }
        
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if (indexPath.section == 0 || headerDataSource[indexPath.section].data[0] == "Favourites" || headerDataSource[indexPath.section].data[0] == "Emergency Contact"){
            return false
        }
        if(headerDataSource[indexPath.section].data[0] == "Groups" && indexPath.row == 0){
            return false
        }
        else{
            return true
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard  (indexPath.section != 0) else{
            let cell = tableView.dequeueReusableCell(withIdentifier: ContactNameTableViewCell.identifier, for: indexPath) as? ContactNameTableViewCell
            cell?.contentView.layoutMargins = UIEdgeInsets.zero
            if(info != nil){
                
                cell?.textField.text = (indexPath.row == 0) ? (info?.firstName) : (info?.lastName)
                
            }
            
            if inputDict["First Name"] != nil && indexPath.row == 0 {
                if let firstName = inputDict["First Name"]{
                    cell?.textField.text = String(describing: firstName)
                }
            }
            if String(describing: inputDict["Last Name"]).isEmpty && indexPath.row == 1 {
                cell?.textField.text = String(describing: inputDict["Last Name"])
            }
            cell?.textField.attributedPlaceholder = NSAttributedString(string:(headerDataSource[indexPath.section].data[indexPath.row]) ,attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
            cell?.textField.delegate = self
            return cell!
        }
        if(headerDataSource[indexPath.section].data[0] == "PhoneNumber" && indexPath.row > 0){

            let cell = tableView.dequeueReusableCell(withIdentifier: PhoneNumberTableViewCell.identifier, for: indexPath) as? PhoneNumberTableViewCell
            if(info != nil){
                if let modelType = info?.phoneNumber[indexPath.row - 1].modelType,let number = info?.phoneNumber[indexPath.row - 1].number{
                    cell?.optionLabel.text = modelType
                    cell?.numInput.text = String(number)
                }
                
                
            }
            else{
                cell?.optionLabel.text = phoneNumModel[indexPath.row-1].modelType
                cell?.numInput.attributedPlaceholder = NSAttributedString(string:"phone",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.5)])
                cell?.cellView.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
                cell?.cellView.tag = indexPath.row
                cell?.numInput.delegate = self
                cell?.numInput.tag = indexPath.row
                
                
                if let number = phoneNumModel[indexPath.row-1].number {
                    
                    cell?.numInput.text = String(number)
                }
            }
            
            return cell!
        }
            
        
        if(headerDataSource[indexPath.section].data[0] == "Address" && indexPath.row > 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: AddressTableViewCell.identifier, for: indexPath) as? AddressTableViewCell
            if(info != nil){
                if let modelType = info?.address?[indexPath.row - 1].modelType{
                    cell?.optionLabel.text = modelType
                }
                if let doorNo = info?.address?[indexPath.row - 1].doorNo{
                    cell?.doorNumTf.text = doorNo
                }
                if let street = info?.address?[indexPath.row - 1].Street{
                    cell?.streetTf.text = street
                }
                if let city = info?.address?[indexPath.row - 1].city{
                    cell?.cityTf.text = city
                }
                if let postcode = info?.address?[indexPath.row - 1].postcode{
                    cell?.postCodeTf.text = postcode
                }
                if let state = info?.address?[indexPath.row - 1].state{
                    cell?.stateTf.text = state
                }
                if let country = info?.address?[indexPath.row - 1].country{
                    cell?.CountryTf.text = country
                }
                
            }
            else{
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
                }
                if let street = addressModel[indexPath.row - 1].Street{
                    cell?.streetTf.text = street
                }
                if let city = addressModel[indexPath.row - 1].city{
                    cell?.cityTf.text = city
                }
                if let postcode = addressModel[indexPath.row - 1].postcode{
                    cell?.postCodeTf.text = String(postcode)
                }
                if let state = addressModel[indexPath.row - 1].state{
                    cell?.stateTf.text = state
                }
                if let country = addressModel[indexPath.row - 1].country{
                    cell?.CountryTf.text = country
                }
            }
            
            return cell!
        }
        
        if (headerDataSource[indexPath.section].data[0] == "Social Profile" && indexPath.row > 0){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SocialProfileTableViewCell.identifier, for: indexPath) as? SocialProfileTableViewCell
            if (info != nil) {
                if let profileType = info?.socialProfile?[indexPath.row - 1].profileType{
                    cell?.optionLabel.text = profileType
                }
                if let link = info?.socialProfile?[indexPath.row - 1].link{
                    cell?.numInput.text = link}
            }
            else{
                cell?.optionLabel.text = socialProfileModel[indexPath.row-1].profileType
                cell?.numInput.attributedPlaceholder = NSAttributedString(string:"Social Profile",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.5)])
                cell?.cellView.tag = indexPath.row
                cell?.numInput.keyboardType = .emailAddress
                cell?.numInput.delegate = self
                cell?.numInput.tag = indexPath.row
                
                cell?.cellView.addTarget(self, action: #selector(socialProfileOptions), for: .touchUpInside)
                if let link = socialProfileModel[indexPath.row - 1].link{
                    cell?.numInput.text = link
                }
            }
            return cell!
        }
        
        if (headerDataSource[indexPath.section].data[0] == "Notes" ){
            let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.identifier) as! NotesTableViewCell
            if info != nil{
                cell.textView.text = info?.notes
            }
            cell.textView.delegate = self
            return cell
        }
        if (headerDataSource[indexPath.section].data[0] == "Favourites"){
            let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteAndEmergencyContactTableViewCell.identifier) as! FavouriteAndEmergencyContactTableViewCell
            cell.text.text = "Favourite"
            cell.images.addTarget(self, action: #selector(tapFavourite), for: .touchUpInside)
            if (info != nil){
                isFavourite = (info?.favourite)!
            }
            if (isFavourite == 0){
                cell.images.setImage(UIImage(systemName: "star"), for: .normal)
                cell.images.tintColor = .systemBlue
            }
            else{
                cell.images.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cell.images.tintColor = .systemBlue
            }
            return cell
        }
        if (headerDataSource[indexPath.section].data[0] == "Emergency Contact" ){
            let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteAndEmergencyContactTableViewCell.identifier) as! FavouriteAndEmergencyContactTableViewCell
            cell.text.text = "Emergency Contact"
            cell.images.addTarget(self, action: #selector(tapEmergency), for: .touchUpInside)
            if (info != nil){
                isEmergencyContact = (info?.emergencyContact)!
            }
            if(isEmergencyContact == 0){
                cell.images.setImage(UIImage(systemName: "staroflife"), for: .normal)
                cell.images.tintColor = .systemRed
                
            }
            else{
                cell.images.setImage(UIImage(systemName: "staroflife.fill"), for: .normal)
                cell.images.tintColor = .systemRed
            }
            
            return cell
        }
        if (headerDataSource[indexPath.section].data[0] == "Groups" && indexPath.row > 0){
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
                if info != nil {
                    cell.textField.text = info?.workInfo!
                }
                cell.textField.tag = indexPath.row - 1
                
                    if(!workInfoArray.isEmpty){
                        cell.textField.text =  workInfoArray[indexPath.row - 1]
                    }
                
            }
            if(indexPath.section == 3){
                cell.textField.tag =  indexPath.row - 1
                if info != nil {
                    cell.textField.text = info?.email?[indexPath.row - 1]
                }
                if indexPath.row-1 < emailArray.count {
                    print( "email id is \(emailArray)")
                    cell.textField.text = emailArray[indexPath.row-1]
                }
            }
            cell.textField.attributedPlaceholder = NSAttributedString(string: (headerDataSource[indexPath.section].data[0]),attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.5)])
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

        if ( headerDataSource[indexPath.section].data[0] == "Address"  && indexPath.row > 0){
            return 300.0
        }
        else if headerDataSource[indexPath.section].data[0] == "Notes" {
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
        if(headerDataSource[indexPath.section].data[indexPath.row] != "Groups" ){
            if (headerDataSource[indexPath.section].data[0] == "PhoneNumber" ){
                phoneNumModel.append(PhoneNumberModel(modelType: "mobile"))
                tableView.reloadData()
            }
            else if (headerDataSource[indexPath.section].data[0] == "Address" ){
                addressModel.append(AddressModel(modelType: "home"))
                tableView.reloadData()
            }
            else if (headerDataSource[indexPath.section].data[0] == "Social Profile" ) {
                
                socialProfileModel.append(SocialProfileModel(profileType: "Twitter"))
                tableView.reloadData()
            }
            else if (headerDataSource[indexPath.section].data[0] == "Favourites"){
                if(isFavourite == 0){
                    isFavourite = 1
                }
                else{
                    isFavourite = 0
                }
                tableView.reloadData()
                
            }
            else if (headerDataSource[indexPath.section].data[0] == "Emergency Contact"){
                if(isEmergencyContact == 0){
                    isEmergencyContact = 1}
                else{
                    isEmergencyContact = 0
                }
                tableView.reloadData()
                
            }
            else if (headerDataSource[indexPath.section].data[0] == "Work Info"){
                if(workInfoArray.isEmpty){
                    workInfoArray.append("")
                    tableView.reloadData()
                    
                }
            }
                else if (headerDataSource[indexPath.section].data[0] == "Email"){
                    emailArray.append("")
                    tableView.reloadData()
                }
                if(headerDataSource[indexPath.section].data[0] != "Favourites" && headerDataSource[indexPath.section].data[0] != "Emergency Contact"){
                    
                    headerDataSource[indexPath.section].data.append(headerDataSource[indexPath.section].data[0])
                    tableView.reloadData()
                    //                tableView.insertRows(at: [IndexPath(row:  headerDataSource[indexPath.section].data.count-1, section: indexPath.section)], with: .bottom)
                }
            
            else{
                if (headerDataSource[indexPath.section].data[0] == "Groups"  && indexPath.row > 0){
                    groups.append(grpData[indexPath.row].groupName)
                    
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
            if let firstName = textField.text{
                if firstName != ""{
      
                    inputDict["First Name"] = firstName}
                else{
                    inputDict["First Name"] = nil
                }
            }
            else{
                inputDict["First Name"] = nil
            }

        case "Last Name":
            if let lastName = textField.text {
                
                if lastName != ""{
                    inputDict["Last Name"] = lastName
                }
                else{
                    inputDict["Last Name"] = nil
                }
            }
            else{
                inputDict["Last Name"] = nil
            }
        case "Work Info":
            if let workInfo = textField.text{
                workInfoArray[textField.tag ] = workInfo
                
                inputDict["Work Info"] = workInfoArray[0]}
            else{
                inputDict["Work Info"] = nil
            }

        case "Email":
            if let email = textField.text{
                print(textField.tag)
                emailArray[textField.tag ] = (email)
                inputDict["Email"] = emailArray}
            else{
                inputDict["Email"] = nil
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
            inputDict["Address"] = addressModel

       
        case "Social Profile":
            if let socialProfile = textField.text{
                socialProfileModel[textField.tag - 1].link = socialProfile
                
            }
            else{
                socialProfileModel[textField.tag - 1].link = nil
            }
            inputDict["Social Profile"] = socialProfileModel

        default:
            return
        }
        
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
        if let notes = textView.text{
            inputDict["Notes"] = notes
        }
        else{
            inputDict["Notes"] = nil
        }
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





