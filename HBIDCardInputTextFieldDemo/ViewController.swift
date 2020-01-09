//
//  ViewController.swift
//  HBIDCardInputTextFieldDemo
//
//  Created by hivebox_tianjun on 2019/8/26.
//  Copyright © 2019 com.fxbox.www. All rights reserved.
//

import UIKit
import PinLayout
class ViewController: UIViewController {
    
    private lazy var cardtextField: HBIdCardInputTextField = {
        let textField = HBIdCardInputTextField()
        textField.placeholder = "请输入身份证号码"
        textField.tag = 10
        textField.textFieldInputType = .idCardInputType
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.editTextMargin = 16
        return textField
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
      
        view.addSubview(cardtextField)
        
        cardtextField.pin.left(16).right(16).height(44).vCenter()
        cardtextField.inputIdCardHandler = { pwd in
            print("pwd = \(pwd)")
        }
        
        
        let textField1 = UITextField()
        textField1.placeholder = "text1"
        textField1.borderStyle = .roundedRect
        textField1.keyboardType = .numberPad
        view.addSubview(textField1)
        textField1.delegate = self
        textField1.pin.above(of: cardtextField, aligned: .left).marginBottom(16).right(16).height(44)
        
        
        
        let textField2 = UITextField()
        textField2.placeholder = "text2"
        textField2.borderStyle = .roundedRect
        textField2.keyboardType = .emailAddress
        view.addSubview(textField2)
        textField2.delegate = self
        textField2.pin.above(of: textField1, aligned: .left).marginBottom(16).right(16).height(44)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
extension ViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == 10 {
            cardtextField.textFieldInputType = .idCardInputType
        } else {
            cardtextField.textFieldInputType = .pureNumberInputType
        }
        return true
    }
}
