//
//  AddTableViewCell.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 05/04/23.
//



import UIKit

class AddTableViewCell: UITableViewCell {

    static var identifier = "AddTableIdentifier"
    
    
    lazy var textField:UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardAppearance = .default
        textField.backgroundColor = .clear
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear

        contentView.addSubview(textField)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureConstraints(){

        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
       
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.text = nil
    }
    
    
}
