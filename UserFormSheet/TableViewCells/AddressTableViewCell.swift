//
//  AddressTableViewCell.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 06/04/23.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

   static var identifier = "AddressTableViewCell"
    lazy var optionButton:UIButton = {
        let button = UIButton()
        return button
    }()
    
    lazy var optionLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .systemBlue
        return label
    }()

    lazy var disclosureIndicator:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.forward")
        imageView.tintColor = .label
        return imageView
    }()
    
    lazy var containerView:UIStackView = {
        let view = UIStackView()

        view.axis = .vertical
        view.spacing = 0
        view.alignment = .fill
        return view
    }()
    
    lazy var horizontalContainer:UIStackView = {
        let view = UIStackView()

        view.axis = .horizontal
        view.spacing = 50
        view.alignment = .fill
        return view
    }()

    lazy var doorNumTf:UITextField = {
        let tf = UITextField()
        
        tf.placeholder = "Door no."
        tf.borderStyle = .none
        return tf
    }()
    
    lazy var streetTf:UITextField = {

            let tf = UITextField()
            tf.placeholder = "Street"
            tf.borderStyle = .none
            return tf
        }()
    
    lazy var cityTf:UITextField = {
        let tf = UITextField()

        tf.placeholder = "City"
        tf.borderStyle = .none
        return tf
    }()
    
    lazy var postCodeTf:UITextField = {
        let tf = UITextField()

        tf.placeholder = "PostCode"
        tf.borderStyle = .none
        return tf
    }()
    
    lazy var stateTf:UITextField = {
        let tf = UITextField()
        tf.placeholder = "State"
        tf.borderStyle = .none
        return tf
    }()
    
    lazy var CountryTf:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Country"
        tf.borderStyle = .none
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(optionButton)
        optionButton.addSubview(optionLabel)
        optionButton.addSubview(disclosureIndicator)
        contentView.addSubview(containerView)
        containerView.addArrangedSubview(doorNumTf)
        containerView.addArrangedSubview(streetTf)
        horizontalContainer.addArrangedSubview(cityTf)
        horizontalContainer.addArrangedSubview(postCodeTf)
        containerView.addArrangedSubview(horizontalContainer)
        containerView.addArrangedSubview(stateTf)
        containerView.addArrangedSubview(CountryTf)
        setUpConstraints()
        cityTf.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        postCodeTf.setContentHuggingPriority(.defaultLow, for: .horizontal)
        cityTf.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        postCodeTf.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpConstraints(){
        optionButton.translatesAutoresizingMaskIntoConstraints = false
        optionLabel.translatesAutoresizingMaskIntoConstraints = false
        disclosureIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        horizontalContainer.translatesAutoresizingMaskIntoConstraints = false
//        doorNumTf.translatesAutoresizingMaskIntoConstraints = false
//        streetTf.translatesAutoresizingMaskIntoConstraints = false
        cityTf.translatesAutoresizingMaskIntoConstraints = false
//        stateTf.translatesAutoresizingMaskIntoConstraints = false
        postCodeTf.translatesAutoresizingMaskIntoConstraints = false
//        CountryTf.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            optionButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            optionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            optionButton.widthAnchor.constraint(equalToConstant: 150),
            optionButton.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            optionLabel.topAnchor.constraint(equalTo: optionButton.topAnchor),
            optionLabel.leadingAnchor.constraint(equalTo: optionButton.leadingAnchor, constant: 5),
            optionLabel.widthAnchor.constraint(equalToConstant: 70),
            optionLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            disclosureIndicator.topAnchor.constraint(equalTo: optionButton.topAnchor,constant: 142),
            disclosureIndicator.leadingAnchor.constraint(equalTo: optionLabel.trailingAnchor,constant: 5),
            disclosureIndicator.widthAnchor.constraint(equalToConstant: 15),
            disclosureIndicator.heightAnchor.constraint(equalToConstant: 17),
            
            horizontalContainer.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 100),
            horizontalContainer.leadingAnchor.constraint(equalTo: optionButton.trailingAnchor),
            horizontalContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            horizontalContainer.heightAnchor.constraint(equalToConstant: 100),
            
            cityTf.topAnchor.constraint(equalTo: contentView.topAnchor),
            cityTf.leadingAnchor.constraint(equalTo: horizontalContainer.leadingAnchor),
            cityTf.widthAnchor.constraint(equalToConstant: 110),
            cityTf.heightAnchor.constraint(equalTo:contentView.heightAnchor),
            
            postCodeTf.topAnchor.constraint(equalTo: contentView.topAnchor),
            postCodeTf.leadingAnchor.constraint(equalTo: cityTf.trailingAnchor,constant: 5),
            postCodeTf.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: 5),
            postCodeTf.heightAnchor.constraint(equalTo:contentView.heightAnchor),
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: optionButton.trailingAnchor),
            containerView.widthAnchor.constraint(equalTo:contentView.widthAnchor),
            containerView.heightAnchor.constraint(equalTo:contentView.heightAnchor)
        ])
        
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        optionLabel.text = "home"
        doorNumTf.text = nil
        streetTf.text = nil
        cityTf.text = nil
        postCodeTf.text = nil
        stateTf.text = nil
        CountryTf.text = nil
    }
    
}
