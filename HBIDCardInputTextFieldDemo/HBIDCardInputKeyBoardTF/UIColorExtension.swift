//
//  UIColorExtension.swift
//  HBIDCardInputTextFieldDemo
//
//  Created by hivebox_tianjun on 2019/8/26.
//  Copyright © 2019 com.fxbox.www. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    /// rgb(a)十进制
    public convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    /// rgb(a)0xffffff十六进制
    public convenience init(_ hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
    
    /// 参数：16进制字符串，不带前缀
    public convenience init(hexStr: String) {
        let hex = strtoul(hexStr, nil, 16)
        self.init(Int(hex))
    }
    
    /// 用自身颜色生成UIImage
    public var image: UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
