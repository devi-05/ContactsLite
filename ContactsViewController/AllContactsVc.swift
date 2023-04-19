//
//  AllContactsVc.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 28/03/23.
//

import UIKit




class AllContactsVc: UITableViewController,UISearchControllerDelegate,UISearchBarDelegate,UISearchResultsUpdating{
    
    var bool:Bool = false
    var filteredData:[Contacts]=[]
    var searchedQuery:String = ""
    var totalContacts = 0
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Devi Sankar"
        label.textColor = .label
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    lazy var mailLabel : UILabel = {
        let label = UILabel()
        label.text = "devi@mail.com"
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
        let view = UIView(frame:CGRect(x: 0, y: 0, width: view.frame.size.width, height: 95))
        view.backgroundColor = .secondarySystemFill
        view.layer.cornerRadius = 10
        return view
    }()
    
   
    lazy var dataCountLabel:UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        label.text = "\(totalContacts) Contacts"
        label.textAlignment = .center
        label.font = .monospacedDigitSystemFont(ofSize: 15, weight: .bold)
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
    var localDataSource:GroupModel?
    lazy var dbContactList:[Contacts] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(passedData == nil){
            refreshDataSource()
            tableView.reloadData()
        }
    }
    
    func refreshDataSource(){
        lazy  var fetchedData = DBHelper.fetchData()
        dbContactList = Helper.decodeToContact(list: fetchedData)
        
         localDataSource = GroupModel(groupName: "Contacts", data: Helper.extractNamesFromFetchedData(lists:(Helper.decodeToContact(list: (DBHelper.fetchSortedData(tableName: "CONTACTS", colName: nil, criteria: ["FIRST_NAME","LAST_NAME"], sortPreference: "DESC"))))))
        
        if (localDataSource?.data.count == 0){
            tableView.backgroundView = addContactView
        }

        else{
            addContactView.isHidden = true
        }
        passedData = localDataSource
        updateTotalContacts()
        
        tableView.reloadData()
    }
    
    var passedData:GroupModel?
    
    init(data:GroupModel?){
        self.passedData = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
     
        
        super.viewDidLoad()
        if(passedData == nil){
            refreshDataSource()
//            passedData = localDataSource
            title = "iPhone"
        }
        else{
            title = passedData?.groupName
            updateTotalContacts()
        }
       
        
        if (passedData?.data.count == 0){
            tableView.backgroundView = addContactView
        }

        else{
            addContactView.isHidden = true
        }
        view.backgroundColor = .systemBackground
        
        setUpNavigationItems()
        
        searchController.searchResultsUpdater = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        addSubviewsToProfileCardLabel()
        
        addSubViewsToSearchResultsView()
        
        setUpConstraints()
        
        setUpCreateContactView()

        tableView.tableHeaderView = profileCardLabel
        
       
            if(totalContacts > 5){
                tableView.tableFooterView = dataCountLabel
            }
            else{
                tableView.tableFooterView = nil
            }
        
        tableView.keyboardDismissMode = .onDrag
        
//        tableView.sectionIndexTrackingBackgroundColor = .black
        
        
    }
    
    
    func updateTotalContacts(){
        for i in 0..<(passedData?.data.count)!{
                   totalContacts+=(passedData?.data[i].rows.count)!
        }
    }

    
    func setUpNavigationItems() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),style: .plain, target: self, action: #selector(addButton))
        
//        title = passedData?.groupName
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        
    }
    func setUpCreateContactView(){
        addContactView.addSubview(imgView)
        addContactView.addSubview(label)
        addContactView.addSubview(createTextButton)
        view.addSubview(addContactView)
        
        imgView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        createTextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([

            imgView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imgView.topAnchor.constraint(equalTo: view.topAnchor,constant: 250),
            
            imgView.widthAnchor.constraint(equalToConstant: 60),
            imgView.heightAnchor.constraint(equalToConstant: 60),
            
            label.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 65),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            label.heightAnchor.constraint(equalToConstant: 20),
            
            createTextButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
            createTextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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
//            searchImage.leadingAnchor.constraint(equalTo: searchResultView.leadingAnchor, constant: 50),
            searchImage.widthAnchor.constraint(equalToConstant: 80),
            searchImage.heightAnchor.constraint(equalToConstant: 80),
            
            searchTextLabel.topAnchor.constraint(equalTo: searchResultView.topAnchor, constant: 380),
            searchTextLabel.leadingAnchor.constraint(equalTo: searchResultView.leadingAnchor, constant: 50),
            searchTextLabel.trailingAnchor.constraint(equalTo: searchResultView.trailingAnchor, constant: -50),
            searchTextLabel.bottomAnchor.constraint(equalTo: searchResultView.bottomAnchor, constant: -350)
            

            
        ])
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if(!bool){
            return filteredData.isEmpty ? (passedData!.data.count) : 1}
        
            return 0
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(!bool){
            
            if filteredData.isEmpty {
                                return  passedData!.data[section].rows.count
            }
            else{
                return  filteredData.count
            }
        }
            return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var name:String = ""
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
       
            if (filteredData.isEmpty){
                name = (passedData!.data[indexPath.section].rows[indexPath.row].firstName)
                if (passedData!.data[indexPath.section].rows[indexPath.row].lastName) != nil {
                    name += " \(passedData!.data[indexPath.section].rows[indexPath.row].lastName!)"
                    
                }
                cell.textLabel?.attributedText = nil
                cell.textLabel?.text = name
            }
            else{
                
                name = filteredData[indexPath.row].firstName
                if filteredData[indexPath.row].lastName != nil{
                    name += " \(filteredData[indexPath.row].lastName!)"
                }
                cell.textLabel?.setHighlighted(name, with: searchedQuery)
            }
            
        
            return cell
        }
    
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        let letters = Array(CharacterSet.uppercaseLetters)
//        let c = letters.map({$0})
        
        if dbContactList.count < 6 {
            return nil
        }
        else{
            return ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"]
        }
    }
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
  
        
        let sectionHeaders = passedData!.data.map({$0.sectionName})
        
        if let ind = sectionHeaders.firstIndex(of: title){
            print(ind)
            return ind
        }
        else{
            var ind = 0
            for i in 0..<sectionHeaders.count{
                if sectionHeaders[i] < title {
                    ind = i
                }
            }
            print(ind)
            return ind
        }
        
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if filteredData.isEmpty{
            return passedData!.data[section].sectionName
        }
        else{
            return ""
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filteredData.isEmpty{
            print("\(passedData!.data[indexPath.section].rows[indexPath.row].firstName) is Selected")
            let vc = ProfilePageViewController(contact: passedData!.data[indexPath.section].rows[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        }
        else{
            print(filteredData[indexPath.row])
            let vc = ProfilePageViewController(contact: filteredData[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
    
    @objc func addButton(){
        let vc = InfoSheetViewController(contact: nil)
        vc.allContactsVc = self
//
        let navVc = UINavigationController(rootViewController:  vc)
//        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: true)
//        print("add ")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //        profileCardLabel.isHidden = true
        //        profileCardLabel.frame.size.height = 0
        tableView.backgroundView = nil
        tableView.tableHeaderView = nil
        tableView.tableFooterView = nil
        tableView.sectionIndexColor = .clear
        print("did begin")
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("end")
        searchBar.resignFirstResponder()

    
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        print("cancel button")
        tableView.sectionIndexColor = .systemBlue
        tableView.tableHeaderView = profileCardLabel
        tableView.tableFooterView = dataCountLabel
        bool = false
        filteredData.removeAll()
        tableView.reloadData()
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("update search results")
        
        guard let text = searchController.searchBar.text else{
            return
        }
        if !text.isEmpty {
            searchTextLabel.text = "No Results for '\(text)'"
            tableView.tableFooterView = nil
            filterInput(input: text)
        }
        else{
            bool = false
            filteredData.removeAll()
            searchResultView.isHidden = true
            tableView.reloadData()
        }
        
        
        
    }
    
    func filterInput(input:String){
        searchedQuery = input
        var tempArr:[String] = []

        
        filteredData.removeAll()
        var rows:[Contacts] = []
        for i in 0..<passedData!.data.count{
           
            for string in passedData!.data[i].rows{
                var name = string.firstName
                if string.lastName != nil{
                    name += " \( string.lastName!)"
                }
                
                if (name.lowercased().contains(input.lowercased())){
                    
                    
                    if !tempArr.contains(name){
                        tempArr.append(name)

                        rows.append(string)
                    }
                    
                    
                    filteredData = rows
                    
                }
                
            }
        }
            
            if tempArr.isEmpty {
                tableView.backgroundView = searchResultView
                searchResultView.isHidden = false
                
                bool = true
                
            }
            else {
              
                searchResultView.isHidden = true
                bool = false
            }
            tableView.reloadData()
            
        }
    
        
        func addToDataSource(contact:Contacts){
            var bool = false
            if(passedData!.data.isEmpty){
                passedData!.data.append(SectionContent(sectionName: String(contact.firstName.first!), rows: [contact]))
            }
            else{
                for i in 0..<passedData!.data.count{
                    if passedData!.data[i].sectionName == String(contact.firstName.first!){
                        passedData!.data[i].rows.append(contact)
                        bool = true
                    }
                }
                if(!bool){
                    passedData!.data.append(SectionContent(sectionName: String(contact.firstName.first!), rows: [contact]))
                }
            }
            
            
            tableView.reloadData()
            
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
