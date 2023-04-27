//
//  NotesTableViewCell.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 26/04/23.
//

import UIKit

class NotesDisplayTableViewCell: UITableViewCell {
    static var identifier = "NotesDisplayTableViewCell"
     lazy var title :UILabel = {
         let label = UILabel()
         label.text = "Notes"
         label.textColor = .label
         label.textAlignment = .justified
         return label
     }()

    lazy var subHeaders:UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(subHeaders)
        contentView.addSubview(title)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureConstraints(){
        title.translatesAutoresizingMaskIntoConstraints = false
        subHeaders.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            title.heightAnchor.constraint(equalToConstant: contentView.frame.size.height/2),
            
            subHeaders.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            subHeaders.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            subHeaders.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            subHeaders.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    
}
