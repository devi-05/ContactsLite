//
//  GroupsTableViewCell.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 10/04/23.
//

import UIKit

class GroupsTableViewCell: UITableViewCell {
    static var identifier = "GroupsTableViewCell"
    lazy var label:UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    lazy var leftSideButton:UIButton = {
        let button = UIButton()
        return button

    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(leftSideButton)
        label.translatesAutoresizingMaskIntoConstraints = false
        leftSideButton.translatesAutoresizingMaskIntoConstraints = false
      
        NSLayoutConstraint.activate([
           
            
            leftSideButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            leftSideButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            leftSideButton.widthAnchor.constraint(equalToConstant: 40),
            leftSideButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: leftSideButton.trailingAnchor,constant: 15),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -15),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil

    }

}
