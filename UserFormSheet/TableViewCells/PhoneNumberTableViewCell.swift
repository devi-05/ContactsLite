//
//  PhoneNumberTableViewCell.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 05/04/23.
//

import UIKit

class PhoneNumberTableViewCell: UITableViewCell {
    let optionValues:[String] = ["mobile","home","work","school","iphone","Apple Watch","main","home fax","work fax","pager","other"]
    
    var myString:String = ""
    
     var size: CGSize = CGSize(width: 0, height: 0)
    
    var tempSize:CGSize = CGSize(width: 0, height: 0)
    


   static var identifier = "PhoneNumberTableViewCell"
    
    lazy var cellView : UIButton = {
        let view = UIButton()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    func calculateSize(){
        for i in optionValues {
            
            myString = i
            
            tempSize =  myString.size(withAttributes: [.font: UIFont.systemFont(ofSize: 20)])
            if (tempSize.width>size.width){
                size = tempSize
            }
        }
        
    }
    
    lazy var optionLabel:UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    lazy var disclosureIndicator:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.forward")
        imageView.contentMode = .scaleAspectFit
//        button.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
//        button.tintColor = .systemGray
        return imageView
       
    }()
    
    lazy var numInput:UITextField = {
        let label = UITextField()
        label.textColor = .label
        label.backgroundColor = .clear
        
        label.borderStyle = .none
        label.keyboardType = .numberPad
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        calculateSize()
        print(size.width)
        contentView.addSubview(cellView)
        cellView.addSubview(optionLabel)
        cellView.addSubview(disclosureIndicator)
        contentView.addSubview(numInput)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureConstraints(){
        
        cellView.translatesAutoresizingMaskIntoConstraints = false

        optionLabel.translatesAutoresizingMaskIntoConstraints = false
        disclosureIndicator.translatesAutoresizingMaskIntoConstraints = false
        numInput.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.widthAnchor.constraint(equalToConstant: 150),
            cellView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            

            
            optionLabel.topAnchor.constraint(equalTo: cellView.topAnchor),
            optionLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor,constant: 10),
            optionLabel.widthAnchor.constraint(equalToConstant: size.width),
            optionLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            disclosureIndicator.topAnchor.constraint(equalTo: cellView.topAnchor,constant: 23),
            disclosureIndicator.leadingAnchor.constraint(equalTo: optionLabel.trailingAnchor,constant: 5),
            disclosureIndicator.widthAnchor.constraint(equalToConstant: 15),
            disclosureIndicator.heightAnchor.constraint(equalToConstant: 17),
            
            numInput.topAnchor.constraint(equalTo: contentView.topAnchor),
            numInput.leadingAnchor.constraint(equalTo: cellView.trailingAnchor),
            numInput.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            numInput.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        numInput.text = nil
        optionLabel.text = "mobile"
    }
    
}
