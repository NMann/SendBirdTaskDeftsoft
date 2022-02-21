//
//  UIColor.swift
//  DemoSendBirdChatApp
//
//  Created by IOS22 on 21/02/22

import Foundation
import UIKit
extension UIColor {
    
    //TO REMOVE THE NAVIGATION BAR LINE
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
