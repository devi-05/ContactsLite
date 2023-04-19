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
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
      
        label.translatesAutoresizingMaskIntoConstraints = false
        
      
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
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
