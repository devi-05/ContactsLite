//
//  EmailAndNotesTableViewCell.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 15/04/23.
//

import UIKit

class EmailTableViewCell: UITableViewCell {

       static var identifier = "EmailTableViewCell"
    lazy var title :UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textColor = .label
        return label
    }()

        lazy var header:UILabel = {
            let label = UILabel()
            label.textColor = .link
            label.textAlignment = .left
            return label
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            contentView.backgroundColor = .secondarySystemBackground
            contentView.layer.masksToBounds = true
            contentView.addSubview(header)
            contentView.addSubview(title)
            configureConstraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        func configureConstraints(){
            title.translatesAutoresizingMaskIntoConstraints = false
            header.translatesAutoresizingMaskIntoConstraints = false
        
            
            NSLayoutConstraint.activate([
                title.topAnchor.constraint(equalTo:contentView.topAnchor, constant: 5),
                title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                title.heightAnchor.constraint(equalToConstant: contentView.frame.size.height/2),
                header.topAnchor.constraint(equalTo:title.bottomAnchor, constant: 5),
                header.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                header.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                header.heightAnchor.constraint(equalToConstant: contentView.frame.size.height/2),
             
            ])
        }
    }


