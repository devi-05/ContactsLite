//
//  FormSheetViewController.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 20/04/23.
//

import UIKit

class FormSheetViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let headerNames:[String] = ["Work Info","Phone Number","Email","Address","Social Profile","Notes","Groups"]
    
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
        let view = UIView(frame: CGRect(x: 10, y: 0, width: view.frame.size.width, height: 250))
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
    lazy var firstNametf:UITextField = {
        let tf = UITextField()
        tf.placeholder = "First Name"
        tf.borderStyle = .roundedRect
        tf.textColor = .label
        tf.backgroundColor = .tertiarySystemBackground.withAlphaComponent(0.5)
        return tf
        
    }()
    lazy var lastNametf:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Last Name"
        tf.borderStyle = .roundedRect
        tf.textColor = .label
        tf.backgroundColor = .tertiarySystemBackground.withAlphaComponent(0.5)
        return tf
        
    }()
    lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .secondarySystemBackground
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Contact"
        view.backgroundColor = .secondarySystemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(cancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(DoneButton))
        
        view.addSubview(photoView)
        addSubviewsToPhotoView()
        tableView.delegate = self
        tableView.dataSource = self
        setUpFirstAndLastname()
        setUpTableView()
        tableView.keyboardDismissMode = .onDrag
        
        if #available(iOS 14.0, *) {
            addPhotoButton.menu = buttonMenu
            addPhotoButton.showsMenuAsPrimaryAction = true
        } else {
            // Fallback on earlier versions
        }
    }
    func setUpFirstAndLastname(){
        view.addSubview(firstNametf)
        view.addSubview(lastNametf)
        firstNametf.translatesAutoresizingMaskIntoConstraints = false
        lastNametf.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            firstNametf.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 10),
            firstNametf.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 1),
            firstNametf.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1),
            firstNametf.heightAnchor.constraint(equalToConstant: 50),
            
            lastNametf.topAnchor.constraint(equalTo: firstNametf.bottomAnchor, constant: 5),
            lastNametf.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1),
            lastNametf.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1),
            lastNametf.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
    func setUpTableView(){
        view.addSubview(tableView)
               tableView.translatesAutoresizingMaskIntoConstraints = false
               NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: lastNametf.bottomAnchor,constant: 5),
                   tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                   tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                   tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
               ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    func addSubviewsToPhotoView() {
        photoView.addSubview(photoLabel)
        photoView.addSubview(addPhotoButton)
        configureConstraints()
    }
    func configureConstraints(){
        
        photoLabel.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoLabel.centerXAnchor.constraint(equalTo: photoView.centerXAnchor),
            photoLabel.topAnchor.constraint(equalTo: photoView.topAnchor,constant: 50),
            photoLabel.widthAnchor.constraint(equalToConstant: 150),
            photoLabel.heightAnchor.constraint(equalToConstant: 150),
            
            addPhotoButton.topAnchor.constraint(equalTo: photoLabel.bottomAnchor),
            addPhotoButton.leadingAnchor.constraint(equalTo: photoLabel.leadingAnchor),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 150),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 40)])
        
        
    }
    @objc func cancelButton(){
        dismiss(animated: true)
    }
    @objc func DoneButton(){
       print("done")
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let images = info[.editedImage] as? UIImage{
            photoLabel.image = images
            photoLabel.layer.cornerRadius = 75
            photoLabel.layer.masksToBounds = true
//            image = images
        }
        
        picker.dismiss(animated: true)
        addPhotoButton.setTitle("Edit Photo", for: .normal)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerNames.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerNames[section]
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "devi"
        
        return cell!
    }
}
