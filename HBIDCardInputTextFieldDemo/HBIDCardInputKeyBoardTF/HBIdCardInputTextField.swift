//
//  HBIdCardInputTextField.swift
//  hivebox
//
//  Created by hivebox_tianjun on 2019/8/27.
//  Copyright © 2019 Ethan. All rights reserved.
//

import UIKit

/// 文本框输入类型
public enum HBIdCardInputTextFieldType: Int {
    /// 身份证输入
    case idCardInputType = 0
    /// 纯数字输入
    case pureNumberInputType = 1
}

/// 用于身份证输入弹框数字键盘添加“X”按钮
class HBIdCardInputTextField: UITextField {

    typealias InputIDCardHandler = (_ idcard: String) -> Void
    var inputIdCardHandler: InputIDCardHandler?
    /// 默认是身份证输入文本框
    var textFieldInputType: HBIdCardInputTextFieldType = .pureNumberInputType {
        didSet {
           
            if textFieldInputType == .idCardInputType {
                NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
                NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:Notification.Name.UIKeyboardWillShow, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:Notification.Name.UIKeyboardWillHide, object: nil)
                 self.keyboardType = .numberPad
              
                self.bgview?.isHidden = false
                
            } else {
                // NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
                // NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
               // self.keyBoardView = nil
               self.bgview?.isHidden = true
            }
          
        }
    }
    /// 设置文本框类型： 身份证输入 、纯数字输入
    /// 编辑文本框文字显示与textfiled的间距
    var editTextMargin: CGFloat = 30.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    private  var bgview: UIView?
    private lazy var xbutton: UIButton = {
        let doneButton = UIButton(type: .custom)
        doneButton.setTitle("X", for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        doneButton.setTitleColor(UIColor.black, for: .normal)
        doneButton.setBackgroundImage(UIColor(0xbac4cf).image, for: .highlighted)
        doneButton.backgroundColor = .white
        doneButton.layer.cornerRadius = 5.0
        doneButton.layer.masksToBounds = true
        doneButton.isHidden = true
        doneButton.addTarget(self, action: #selector(xButtonAction(_:)), for: .touchUpInside)
        return doneButton
    }()
    /// 键盘按键父视图
    private var keyBoardView: UIView?
    /// 键盘父视图离keywindow底部间距
    private var keyBoardViewToBottomMargin: CGFloat = 0.0
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("HBIDCardInputKeyBoardTF init")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var frame = bounds
        frame.origin.x += editTextMargin
        return frame
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        var frame = bounds
        frame.origin.x += editTextMargin
        return frame
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var frame = bounds
        frame.origin.x += editTextMargin
        return frame
    }
}
extension HBIdCardInputTextField {
    private func setUpData() {
       
        self.addTarget(self, action: #selector(textDidCHange(_ :)), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:Notification.Name.UIKeyboardWillHide, object: nil)
       
    }
 
    @objc private func keyboardWillShow(_ notification: Notification) {
       print("keyboardWillShow =\(notification)")
        print("type = \(textFieldInputType.rawValue)")
        /// 遍历按键的父视图
        /// UIWindow-UIRemoteKeyBoardWindow-UIInputWindowController-UIInputSetContainerView-
        /// UICompatibilityInputViewController-UIKeyboardAutomatic-UIKeyboardImpl-
        /// UIKeyboardLayoutStar-UIKBKeyplaneView
        DispatchQueue.main.async {
            let keyBoardLayoutStarView =  UIApplication.shared.windows.last?
                .subviews.first?.subviews.first?.subviews.last?
                .subviews.first?.subviews.first?.subviews.first?.subviews
            var xbuttonY: CGFloat = 0.0
            if self.keyBoardView == nil {
                if let planeView = keyBoardLayoutStarView {
                    for subPlaneView in planeView {
                        if subPlaneView.description.hasPrefix("<UIKBKeyplaneView") {
                            self.keyBoardView = subPlaneView
                            /// 获取键盘最后一个按键
                            if let keyView = subPlaneView.subviews.last, keyView.description.hasPrefix("<UIKBKeyView") {
                                self.keyBoardViewToBottomMargin = subPlaneView.frame.size.height - keyView.frame.size.height - keyView.frame.origin.y
                                break
                            }
                        }
                    }
                }
                if let planView = self.keyBoardView {
                    
                    if  self.bgview == nil {
                        let bacgview = UIView()
                        bacgview.backgroundColor = .red
                        self.bgview = bacgview
                        planView.addSubview(bacgview)
                        bacgview.addSubview(self.xbutton)
                        planView.isUserInteractionEnabled = true
                        
                        xbuttonY = planView.frame.size.height - ((planView.frame.size.height - self.keyBoardViewToBottomMargin)/4.0) - self.keyBoardViewToBottomMargin
                        bacgview.pin.left().top(xbuttonY).height((planView.frame.size.height - self.keyBoardViewToBottomMargin)/4.0).width((planView.frame.size.width) / 3.0)
                        self.xbutton.isHidden = false
                        self.xbutton.pin.left(5).top(5).right().bottom(2)
                    }
                    
                    
                    
                }
            }
        }
        if textFieldInputType == .idCardInputType {
            self.bgview?.isHidden = false
        } else {
            self.bgview?.isHidden = true
        }
    }
    @objc private func keyboardWillHide(_ notification: Notification) {
        DispatchQueue.main.async {
            self.resignFirstResponder()
            self.bgview?.isHidden = true
            self.keyBoardView = nil
        }
    }
    @objc private func xButtonAction(_ sender: UIButton) {
        self.text = (self.text ?? "").appending("X")
        textDidCHange(self)
    }
    @objc private func textDidCHange(_ textField: UITextField) {
        inputIdCardHandler?(textField.text ?? "")
    }

}
