//
//  EmailAndNotesTableViewCell.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 15/04/23.
//

import UIKit

class EmailAndNotesTableViewCell: UITableViewCell {

       static var identifier = "EmailAndNotesTableViewCell"
   

        lazy var header:UILabel = {
            let label = UILabel()
        
            label.textColor = .link
            label.textAlignment = .left
        
            return label
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            contentView.backgroundColor = .secondarySystemBackground
//            contentView.layer.cornerRadius = 10
            contentView.layer.masksToBounds = true
           
            contentView.addSubview(header)
            configureConstraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        func configureConstraints(){
          
            header.translatesAutoresizingMaskIntoConstraints = false
        
            
            NSLayoutConstraint.activate([
            
                
                
                header.topAnchor.constraint(equalTo:contentView.topAnchor, constant: 5),
                header.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                header.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                header.heightAnchor.constraint(equalToConstant: contentView.frame.size.height/2),
             
            ])
        }
    }


