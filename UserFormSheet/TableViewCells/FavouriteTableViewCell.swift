//
//  FavouriteTableViewCell.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 09/04/23.
//

import UIKit

class FavouriteAndEmergencyContactTableViewCell: UITableViewCell {

    static var identifier = "FavouriteTableViewCell"

    
    lazy var textButton:UIButton = {
        let button = UIButton()
        
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        button.titleLabel?.textAlignment = .left
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(textButton)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpConstraints(){
        textButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
          textButton.topAnchor.constraint(equalTo: contentView.topAnchor),
          textButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
          textButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
          textButton.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
        ])
    }
    
}
