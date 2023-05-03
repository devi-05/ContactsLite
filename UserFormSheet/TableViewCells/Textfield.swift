//
//  Textfield.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 03/05/23.
//

import UIKit

class Textfield: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpTextField(){
        self.borderStyle = .none
    }
   

}
