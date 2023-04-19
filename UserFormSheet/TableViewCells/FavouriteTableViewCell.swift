//
//  FavouriteTableViewCell.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 09/04/23.
//

import UIKit

class FavouriteAndEmergencyContactTableViewCell: UITableViewCell {

    static var identifier = "FavouriteTableViewCell"
    
    lazy var text:UILabel = {
        let text = UILabel()
        
        text.textColor = .label
        text.textAlignment = .left
        return text
    }()
    
    lazy var images:UIButton = {
        let button = UIButton()
       
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(text)
        contentView.addSubview(images)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpConstraints(){
        text.translatesAutoresizingMaskIntoConstraints = false
        images.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            text.topAnchor.constraint(equalTo: contentView.topAnchor),
            text.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            text.widthAnchor.constraint(equalToConstant: 250),
            text.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            images.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 20),
            images.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            images.widthAnchor.constraint(equalToConstant: 20),
            images.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}
