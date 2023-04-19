//
//  ImagePickerViewController.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 31/03/23.
//

import UIKit

class ImagePickerViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var delegate:ImageDelegate?
    lazy var photoLabel:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .gray
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var galleryIcon:UIImageView = {
        let button = UIImageView() //photo.on.rectangle.angled
       
        button.image = UIImage(systemName: "photo.on.rectangle.angled")
        button.tintColor = .gray
        return button
    }()

    lazy var cameraIcon:UIImageView = {
        let button = UIImageView()
        button.image = UIImage(systemName: "camera.circle.fill")
        button.tintColor = .gray
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select image"
        view.addSubview(photoLabel)
        view.addSubview(cameraIcon)
        view.addSubview(galleryIcon)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(Done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(Cancel))
        view.backgroundColor = .systemBackground
        photoLabel.translatesAutoresizingMaskIntoConstraints = false
        cameraIcon.translatesAutoresizingMaskIntoConstraints = false
        galleryIcon.translatesAutoresizingMaskIntoConstraints = false
        let camTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(camTapped))
            cameraIcon.isUserInteractionEnabled = true
            cameraIcon.addGestureRecognizer(camTapGestureRecognizer)
        let galleryTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(galleryTapped))
            galleryIcon.isUserInteractionEnabled = true
            galleryIcon.addGestureRecognizer(galleryTapGestureRecognizer)
        
        NSLayoutConstraint.activate([
            photoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: 50),
            photoLabel.widthAnchor.constraint(equalToConstant: 300),
            photoLabel.heightAnchor.constraint(equalToConstant: 300),
            
            cameraIcon.topAnchor.constraint(equalTo: photoLabel.bottomAnchor, constant: 20),
            cameraIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            cameraIcon.widthAnchor.constraint(equalToConstant: 70),
            cameraIcon.heightAnchor.constraint(equalToConstant: 70),
            
            galleryIcon.topAnchor.constraint(equalTo: photoLabel.bottomAnchor, constant: 20),
            galleryIcon.leadingAnchor.constraint(equalTo: cameraIcon.trailingAnchor,constant: 100),
            galleryIcon.widthAnchor.constraint(equalToConstant: 70),
            galleryIcon.heightAnchor.constraint(equalToConstant: 70)
        ])
     
    }
    @objc func Done(){
        
        delegate?.getImage(images: photoLabel.image!)
        dismiss(animated: true)
    }
    @objc func Cancel(){
        dismiss(animated: true)
    }
    @objc func camTapped(){
      
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @objc func galleryTapped(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        if let images = info[.editedImage] as? UIImage{
            photoLabel.image = images
            photoLabel.layer.cornerRadius = 150
            photoLabel.layer.masksToBounds = true
        }
        picker.dismiss(animated: true)
    }
    


}
