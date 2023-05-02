//
//  AllContactsVc.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 28/03/23.
//

import UIKit




class AllContactsVc: UITableViewController,UISearchControllerDelegate{
    lazy var navigationBarTitle:String? = nil
    lazy var isSearchActive:Bool = false
    lazy var passedData:[SectionContent]? = nil
    lazy var filteredData:[Contact]=[]
    lazy var searchedQuery:String = ""
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Devi Sankar"
        label.textColor = .label
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    lazy var mailLabel : UILabel = {
        let label = UILabel()
        label.text = "devi@gmail.com"
        label.textColor = .secondaryLabel
        return label
    }()
    lazy var imageView :UIImageView = {
        let imageView = UIImageView()
        imageView.image =  UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .systemGray
        return imageView
    }()
    lazy var profileCardLabel:UIView = {
        let view = UIView(frame:CGRect(x: 25, y: 0, width: view.frame.size.width, height: 95))
        view.backgroundColor = .secondarySystemFill
        view.layer.cornerRadius = 10
        return view
    }()
    lazy var dataCountLabel:UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.backgroundColor = .tertiarySystemBackground
        label.textColor = .label
        return label
    }()
    lazy var searchController:UISearchController = {
        let searchBar = UISearchController()
        searchBar.delegate = self
        searchBar.searchBar.delegate = self
        return searchBar
    }()
    
    lazy var searchImage:UIImageView = {
        let images = UIImageView()
        images.image = UIImage(systemName: "magnifyingglass")
        images.tintColor = .label.withAlphaComponent(0.4)
        return images
    }()
    
    lazy var searchTextLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label.withAlphaComponent(0.7)
        return label
    }()
    
    lazy var searchResultView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.isHidden = true
        return view
    }()
    
    lazy var addContactView:UIView = {
        let view = UIView()
        return view
        
    }()
    lazy var imgView:UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "person.circle.fill")
        imgView.tintColor = .secondaryLabel
        return imgView
    }()
    
    lazy var label:UILabel = {
        let label = UILabel()
        label.text = "Contacts you've added will appear here"
        label.textColor = .label.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 15, weight: .light)
        return label
    }()
    lazy var createTextButton:UIButton = {
        let button = UIButton()
        button.setTitle("Create New Contact", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(addButton), for: .touchUpInside)
        return button
    }()
     

    init(grpName:String){
        
        super.init(nibName: nil, bundle: nil)
        self.navigationBarTitle = grpName
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        // when view appears this function is called so if i passed the data passedData passed data wont be nil it fetches data from db
        
        if let passedData  = passedData{
            dataCountLabel.text = " \(passedData.getTotalContacts()) Contacts"
            refreshDataSource()
            tableView.reloadData()
        }
        
    }
    override func viewDidLoad() {
     
        super.viewDidLoad()
        title = navigationBarTitle
        view.backgroundColor = .systemBackground
        tableView.backgroundView = addContactView
        refreshDataSource()
        setUpNavigationItems()
        addSubviewsToProfileCardLabel()
        addSubViewsToSearchResultsView()
        setUpConstraints()
        setUpCreateContactView()
        searchController.searchResultsUpdater = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableHeaderView = profileCardLabel
        tableView.tableFooterView = dataCountLabel
        tableView.keyboardDismissMode = .onDrag
    }
    
    func refreshDataSource(){
        // data fetches grpname as key and [sectionContent] as value
        let data =  Helper.getGroupListWithData()
        // passed data now filters records as per title
        if let navigationBarTitle = navigationBarTitle {
            passedData = data[navigationBarTitle]
        }
        // if there is zero contacts
        if (passedData?.count == 0){
            
            addContactView.isHidden = false
            dataCountLabel.isHidden = true
        }

        else{

            addContactView.isHidden = true
            if let passedData = passedData{
                if (passedData.getTotalContacts() > 5){
                    dataCountLabel.isHidden = false
                }
                else{
                    dataCountLabel.isHidden = true
                }
            }
            else{
                dataCountLabel.isHidden = true
            }
        }

        
        tableView.reloadData()
    }

    func setUpNavigationItems() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),style: .plain, target: self, action: #selector(addButton))
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        
    }
    func setUpCreateContactView(){
        addContactView.addSubview(imgView)
        addContactView.addSubview(label)
        addContactView.addSubview(createTextButton)
//        tableView.addSubview(addContactView)
        
//        addContactView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.backgroundColor = .darkGray
//        addContactView.backgroundColor = .cyan
        imgView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        createTextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
//            addContactView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
//            addContactView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
//            addContactView.widthAnchor.constraint(equalToConstant: 400),
//            addContactView.heightAnchor.constraint(equalToConstant: 400),

            imgView.centerXAnchor.constraint(equalTo: addContactView.centerXAnchor),
            imgView.centerYAnchor.constraint(equalTo: addContactView.centerYAnchor),
//            imgView.topAnchor.constraint(equalTo: addContactView.topAnchor),
            imgView.widthAnchor.constraint(equalToConstant: 60),
            imgView.heightAnchor.constraint(equalToConstant: 60),
            
            label.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: addContactView.leadingAnchor, constant: 65),
            label.trailingAnchor.constraint(equalTo: addContactView.trailingAnchor, constant: -55),
            label.heightAnchor.constraint(equalToConstant: 20),
            
            createTextButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
            createTextButton.centerXAnchor.constraint(equalTo: addContactView.centerXAnchor),
            createTextButton.widthAnchor.constraint(equalToConstant: 170),
            createTextButton.heightAnchor.constraint(equalToConstant: 50)
        ])

    }
    
    
    func addSubviewsToProfileCardLabel(){
        
        profileCardLabel.addSubview(imageView)
        profileCardLabel.addSubview(nameLabel)
        profileCardLabel.addSubview(mailLabel)
    }
    
    func addSubViewsToSearchResultsView(){
        searchResultView.addSubview(searchImage)
        searchResultView.addSubview(searchTextLabel)
    }
    
    func setUpConstraints(){
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        mailLabel.translatesAutoresizingMaskIntoConstraints = false
        
       
        searchImage.translatesAutoresizingMaskIntoConstraints = false
        searchTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            
            imageView.topAnchor.constraint(equalTo: profileCardLabel.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: profileCardLabel.leadingAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.topAnchor.constraint(equalTo: profileCardLabel.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: profileCardLabel.trailingAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            mailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            mailLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 22),
            mailLabel.trailingAnchor.constraint(equalTo: profileCardLabel.trailingAnchor, constant: -10),
            mailLabel.heightAnchor.constraint(equalToConstant: 30),
            
            
            searchImage.centerXAnchor.constraint(equalTo: searchResultView.centerXAnchor,constant: -10),
            searchImage.topAnchor.constraint(equalTo: searchResultView.topAnchor,constant: 300),
            searchImage.widthAnchor.constraint(equalToConstant: 80),
            searchImage.heightAnchor.constraint(equalToConstant: 80),
            
            searchTextLabel.topAnchor.constraint(equalTo: searchResultView.topAnchor, constant: 380),
            searchTextLabel.leadingAnchor.constraint(equalTo: searchResultView.leadingAnchor, constant: 50),
            searchTextLabel.trailingAnchor.constraint(equalTo: searchResultView.trailingAnchor, constant: -50),
            searchTextLabel.bottomAnchor.constraint(equalTo: searchResultView.bottomAnchor, constant: -350)
            

            
        ])
    }
    
    func filterInput(input:String){
        searchedQuery = input
        var filteredArr:[String] = []

        
        filteredData.removeAll()
        var rows:[Contact] = []
        for i in 0..<(passedData?.count)!{
           
            for string in passedData![i].rows{
                let name = string.fullName()
                
                
                if (name.lowercased().contains(input.lowercased())){
                    
                    
                    if !filteredArr.contains(name){
                        filteredArr.append(name)

                        rows.append(string)
                    }
                    
                    
                    filteredData = rows
                    
                }
                
            }
        }
            
            if filteredArr.isEmpty {
                tableView.backgroundView = searchResultView
                searchResultView.isHidden = false

                
            }
            else {
                searchResultView.isHidden = true
                
            }
            tableView.reloadData()
            
        }

    @objc func addButton(){
        let vc = InfoSheetViewController(contact: nil)
        vc.allContactsVc = self
        if (title != "Contacts"){
            vc.isAddedByGrp = title
        }
        let navVc = UINavigationController(rootViewController:  vc)

        present(navVc, animated: true)

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        print("&&&& \(isSearchActive)")
        if(isSearchActive){
            return filteredData.isEmpty ? 0 : 1
        }
        else{
            
            if let passedData = passedData{
                           return  (passedData.count)
                       }
                       else{
                           return 0
                       }
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(!isSearchActive ){
            
            if filteredData.isEmpty {
                if let passedData = passedData{
                    return  (passedData[section].rows.count)
                }
            }
        }
            else{
                return  filteredData.count
            }
        
       
            return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var name:String = ""
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        if (filteredData.isEmpty){
                if let contact = passedData?.getContact(indexPath: indexPath){
                    name = contact.fullName()
                }

                cell.textLabel?.attributedText = nil
                cell.textLabel?.text = name
            }
            else{
                
                name = filteredData[indexPath.row].fullName()
                cell.textLabel?.setHighlighted(name, with: searchedQuery)
            }
            
        
            return cell
        }
    
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        let letters = Array(CharacterSet.uppercaseLetters)
//        let c = letters.map({$0})
        if let passedData = passedData{
            if passedData.count < 6 {
                return nil
            }
            
            else{
                return nil
            }
        }
        else{
            return ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"]
        }
    }
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
  
        
        let sectionHeaders = passedData?.map({$0.sectionName})
        
        if let ind = sectionHeaders?.firstIndex(of: title){
          
            return ind
        }
        else{
            var ind = 0
            for i in 0..<sectionHeaders!.count{
                if sectionHeaders![i] < title {
                    ind = i
                }
            }
          
            return ind
        }
        
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if (!isSearchActive){
            return passedData?[section].sectionName
        }
        else{
            return ""
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc:ProfilePageViewController
        if filteredData.isEmpty{
            if let passedData = passedData {
                vc = ProfilePageViewController(contact: (passedData.getContact(indexPath: indexPath)))
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        else{
           
             vc = ProfilePageViewController(contact: filteredData[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
          let alertController = UIAlertController(title: nil, message: "Are you sure you want to delete this contact?", preferredStyle: .alert)
            
            let delAction = UIAlertAction(title: "Delete", style: .destructive){ _ in
                if let contact = self.passedData?.getContact(indexPath: indexPath){
                    DBHelper.deleteContact(contactId: contact.contactId)
                    self.refreshDataSource()
                }
                
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            
            alertController.addAction(delAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true)
            
            return
        }
           
           
            tableView.reloadData()
        }
    
       
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if (title == "Contacts"){
            let config = UIContextMenuConfiguration(identifier: nil,previewProvider: nil){ _ in
                let viewProfile = UIAction(title:"View",image: UIImage(systemName: "person.circle"),identifier:nil,discoverabilityTitle: nil,state: .off)
                { _ in
                    
                    if self.filteredData.isEmpty{
                        if let passedData = self.passedData{
                            let vc = ProfilePageViewController(contact: passedData.getContact(indexPath: indexPath))
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    else{
                        
                        let vc = ProfilePageViewController(contact: self.filteredData[indexPath.row])
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                let call = UIAction(title:"Call",image: UIImage(systemName: "phone.circle"),identifier:nil,discoverabilityTitle: nil,state: .off){ _ in
                    let alertController = UIAlertController(title: nil, message: "Are You sure you want to make a call", preferredStyle: .alert)
                    
                    let callAction = UIAlertAction(title: "Call", style: .default){ _ in
                        if let passedData = self.passedData{
                            if let number = passedData.getContact(indexPath: indexPath).phoneNumber[indexPath.row].number{
                                Helper.makeACall(number: String(number))
                            }
                        }
                        else{
                            let alertController = UIAlertController(title: nil, message: "Call Failed", preferredStyle: .alert)
                            
                            let okAction = UIAlertAction(title: "Ok", style: .default){ _ in
                                
                                //                        self.dismiss(animated: true)
                            }
                            
                            
                            alertController.addAction(okAction)
                            
                            self.present(alertController, animated: true)
                            
                            return
                        }
                        
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
                            
                    alertController.addAction(cancelAction)
                    alertController.addAction(callAction)
                    self.present(alertController, animated: true)
                            
                            return
                        }
                    
                
                
                return UIMenu(title: "",image: nil,identifier: nil,children: [viewProfile,call])
            }
            return config
        }
        else{
            let config = UIContextMenuConfiguration(identifier: nil,previewProvider: nil){ _ in
                let viewProfile = UIAction(title:"Remove From Group",image: UIImage(systemName: "person.circle"),identifier:nil,discoverabilityTitle: nil,state: .off)
                { _ in
                    
                    print("remove")
                }
                let call = UIAction(title:"Delete Contact",image: UIImage(systemName: "phone.circle"),identifier:nil,discoverabilityTitle: nil,state: .off){ _ in
                    
                    
                    print("delete")
                    
                }
                return UIMenu(title: "",image: nil,identifier: nil,children: [viewProfile,call])
            }
            return config
        }
    }
    
        
    }
    
extension UILabel{
    func setHighlighted(_ text: String, with search: String) {
          let attributedText = NSMutableAttributedString(string: text)
          let range = NSString(string: text).range(of: search, options: .caseInsensitive)
        let highlightColor = UIColor.systemBlue
        let highlightedAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: highlightColor,
            NSAttributedString.Key.font :UIFont.systemFont(ofSize: 18, weight: .bold)]
          
          attributedText.addAttributes(highlightedAttributes, range: range)
          self.attributedText = attributedText
      }
    
}

extension AllContactsVc:UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //        profileCardLabel.isHidden = true
        //        profileCardLabel.frame.size.height = 0
        addContactView.isHidden = true
        tableView.backgroundView = nil
        tableView.tableHeaderView = nil
        dataCountLabel.isHidden = true
//        tableView.tableFooterView = nil
        tableView.sectionIndexColor = .clear
        print("did begin")
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearchActive = false
        print("end")
        searchBar.resignFirstResponder()
        addContactView.isHidden = false
    
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        print("cancel button")
//        tableView.backgroundView = addContactView
        tableView.sectionIndexColor = .systemBlue
        tableView.tableHeaderView = profileCardLabel
//        tableView.tableFooterView = dataCountLabel
        dataCountLabel.isHidden = false
        isSearchActive = false
        refreshDataSource()
        

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearchActive = true
    }
}

extension AllContactsVc : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        print("update search results")
//        isSearchActive = false
        guard let text = searchController.searchBar.text else{
            return
        }
        if !text.isEmpty {
            searchTextLabel.text = "No Results for '\(text)'"
            addContactView.isHidden = true
            dataCountLabel.isHidden = true
//            tableView.tableFooterView = nil
            filterInput(input: text)
        }
        else{
            isSearchActive = false
            filteredData.removeAll()
            searchResultView.isHidden = true
            addContactView.isHidden = false
//            tableView.tableFooterView = dataCountLabel
//            dataCountLabel.isHidden = false
            
        }
        tableView.reloadData()
    
        
    }
}
