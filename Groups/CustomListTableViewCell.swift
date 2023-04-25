//
//  CustomListTableViewCell.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 09/04/23.
//

import UIKit

class CustomListTableViewCell: UITableViewCell {

   static var identifier = "CustomListTableViewCell"
    lazy var textField:UITextField = {
       let textField = UITextField()
        textField.placeholder = "Enter List name"
        textField.keyboardAppearance = .alert
        textField.becomeFirstResponder()
        textField.tag = 0
        textField.borderStyle = .roundedRect
        return textField
    }()
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
     
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.text = nil
    }
}
