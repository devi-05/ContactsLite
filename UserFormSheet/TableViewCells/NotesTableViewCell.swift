//
//  NotesTableViewCell.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 07/04/23.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

    static var identifier:String = "NotesTableViewCell"
    
    lazy var textView:UITextView = {
        let textView = UITextView()
        textView.text = "Notes"
        textView.textColor = UIColor.gray
        textView.keyboardType = .alphabet
//        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 20, weight: .regular)
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textView)
        setUpConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraints(){
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor,constant: 10),
            textView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            textView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
    }
    
}
