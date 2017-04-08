//
//  Util.swift
//  SGSenate
//
//  Created by Steven Hurtado on 2/22/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Util: NSObject
{
    static var onSignOutNotification = "onSignOutNotification"
    
    static var _currentUserName : String?
    static var _currentUser : FIRUser?
    
    class func invokeAlertMethod(_ strTitle: NSString, strBody: NSString, delegate: AnyObject?)
    {
        let alert = UIAlertController(title: strTitle as String, message: strBody as String, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Okay", style: .default){ _ in}
        
        alert.addAction(action1)
        
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC?.present(alert, animated: true){}
    }
}

class CustomTap : UITapGestureRecognizer
{
    var indexPath : IndexPath = IndexPath()
}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension UIColor
{
    //sg colors
    static var myCreamOrange: UIColor
    {
        //FA7B54
        return UIColor(red: 250.0/255.0, green: 123.0/255.0, blue: 84.0/255.0, alpha: 1)
    }
    
    static var myDullBlue: UIColor
    {
        //5B7FA4
        return UIColor(red: 91.0/255.0, green: 127.0/255.0, blue: 164.0/255.0, alpha: 1)
    }
    
    static var groupTableViewCell: UIColor
    {
        //EBEBF1
        return UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 241.0/255.0, alpha: 1)
    }
    
    
    //other colors
    static var myOffWhite: UIColor
    {
        //FAFAFA
        return UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1)
    }
    
    static var mySalmonRed: UIColor
    {
        //F55D3E
        return UIColor(red: 245.0/255.0, green: 93.0/255.0, blue: 62.0/255.0, alpha: 1)
    }
    
    static var myRoseMadder: UIColor
    {
        //D72638
        return UIColor(red: 215.0/255.0, green: 38.0/255.0, blue: 56.0/255.0, alpha: 1)
    }
    
    static var myOnyxGray: UIColor
    {
        //878E88
        return UIColor(red: 135.0/255.0, green: 142.0/255.0, blue: 136.0/255.0, alpha: 1)
    }
    
    static var myTimberWolf: UIColor
    {
        //DAD6D6
        return UIColor(red: 218.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 1)
    }
    
    
    static var myMatteGold: UIColor
    {
        //F7CB15
        return UIColor(red: 247.0/255.0, green: 203.0/255.0, blue: 21.0/255.0, alpha: 1)
    }
    
    static var twitterBlue: UIColor
    {
        //00aced
        return UIColor(red: 0.0/255.0, green: 172.0/255.0, blue: 237.0/255.0, alpha: 1)
    }
}
