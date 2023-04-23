//
//  ContactNameTableViewCell.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 31/03/23.
//

import UIKit

class ContactNameTableViewCell: UITableViewCell {

    static var identifier = "ContactNameTableViewCell"
    
    lazy var textField:UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear

        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 15),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15 ),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            textField.heightAnchor.constraint(equalToConstant: 50),
           
            
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
