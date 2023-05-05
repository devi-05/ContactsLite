//
//  ListsTableViewCell.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 03/05/23.
//

import UIKit

class ListsTableViewCell: UITableViewCell {

    static let identifier = "ListsTableViewCell"
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.tag = 200
        label.resignFirstResponder()
        return label
    }()
    
    private lazy var textField:UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "List Name"
        textField.tag = 0
        textField.allowsEditingTextAttributes = false
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        contentView.addSubview(countLabel)
        accessoryType = .disclosureIndicator
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -70),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            countLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            countLabel.widthAnchor.constraint(equalToConstant: 40),
            countLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func setTextFieldEditing(_ editing: Bool) {
        textField.allowsEditingTextAttributes = editing
        if editing {
            textField.becomeFirstResponder()
            textField.selectAll(nil)
        }
    }
    
    func configureTextFieldText(_ string: String) {
        textField.text = string
    }
    
    func configureCount(_ string: String) {
        countLabel.text = string
    }
    
}
