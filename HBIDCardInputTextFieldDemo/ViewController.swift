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
    
    override func viewDidLoad() {
        super.viewDidLoad()
         let textField = HBIDCardInputKeyBoardTF()
        view.backgroundColor = .white
        textField.placeholder = "请输入身份证号码"
        view.addSubview(textField)
        textField.borderStyle = .roundedRect
        textField.editTextMargin = 16
        textField.pin.left(16).right(16).height(44).vCenter()
        textField.inputIdCardHandler = { pwd in
            print("pwd = \(pwd)")
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
extension UITextField {
   
}
