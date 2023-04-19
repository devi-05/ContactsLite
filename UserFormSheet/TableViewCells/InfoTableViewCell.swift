//
//  InfoTableViewCell.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 31/03/23.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    static var identifier = "InfoTableIdentifier"
    

    
    lazy var textLabels:UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        return label
        
    }()
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear

        contentView.addSubview(textLabels)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureConstraints(){

        textLabels.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            textLabels.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textLabels.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            textLabels.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            textLabels.heightAnchor.constraint(equalToConstant: 40)
        ])
       
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabels.text = nil
    }
    
}
