//
//  CustomListTableViewCell1.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 10/04/23.
//

import UIKit

class CustomListTableViewCell1: UITableViewCell {

    static var identifier = "CustomListTableViewCell1"
     lazy var label1:UILabel = {
        let label = UILabel()
         label.textColor = .label
         label.numberOfLines = 0
         label.lineBreakMode = .byWordWrapping
         label.tag = 100
         return label
     }()
     lazy var label2:UILabel = {
         let label = UILabel()
         label.textColor = .gray
         label.numberOfLines = 0
         label.textAlignment = .center
         label.tag = 200
         label.resignFirstResponder()
         return label
     }()
     lazy var disclosureIndicator:UIButton = {
         let button = UIButton()
         button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
         button.tintColor = .gray
         return button
     }()
     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
         contentView.addSubview(label1)
         contentView.addSubview(label2)
         contentView.addSubview(disclosureIndicator)
         label1.translatesAutoresizingMaskIntoConstraints = false
         label2.translatesAutoresizingMaskIntoConstraints = false
         disclosureIndicator.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             label1.topAnchor.constraint(equalTo: contentView.topAnchor),
             label1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
             label1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -70),
             label1.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
             
             label2.topAnchor.constraint(equalTo: contentView.topAnchor),
             label2.leadingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -70),
             label2.widthAnchor.constraint(equalToConstant: 40),
             label2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
             
             disclosureIndicator.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
             disclosureIndicator.leadingAnchor.constraint(equalTo: label2.trailingAnchor, constant: 5),
             disclosureIndicator.widthAnchor.constraint(equalToConstant: 30),
             disclosureIndicator.heightAnchor.constraint(equalToConstant: 30)
             
         ])
         
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     override func prepareForReuse() {
         super.prepareForReuse()
         label1.text = nil
         label2.text = nil
     }
}
