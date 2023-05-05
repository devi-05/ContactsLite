//
//  ProfPageTableViewCell.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 15/04/23.
//

import UIKit

class ProfPageTableViewCell: UITableViewCell {

   static var identifier = "ProfPageTableViewCell"

    lazy var header:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    lazy var subHeader:UILabel = {
        let label = UILabel()
        label.textColor = .link
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
//        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.addSubview(header)
        contentView.addSubview(subHeader)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureConstraints(){
        header.translatesAutoresizingMaskIntoConstraints = false
        subHeader.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo:contentView.topAnchor, constant: 10),
            header.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            header.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            header.heightAnchor.constraint(equalToConstant: contentView.frame.size.height/2),
            
            subHeader.topAnchor.constraint(equalTo:header.bottomAnchor, constant: 5),
            subHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            subHeader.heightAnchor.constraint(equalToConstant: contentView.frame.size.height/2)
            
        ])
    }
}
