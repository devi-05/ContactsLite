//
//  Textfield.swift
//  ContactsLite
//
//  Created by devi-pt6261 on 03/05/23.
//

import UIKit

class Textfield: UITextField {
    
    var textFieldId:Int
    init(textFieldId:Int){
        self.textFieldId = textFieldId
        super.init(frame: .zero)
        
        setUpTextField()
    }

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setUpTextField()
//    }
//    convenience init() {
//        self.init()
////        self.init(frame: .zero)
//        setUpTextField()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpTextField(){
        self.borderStyle = .none
    }
   
    
}
