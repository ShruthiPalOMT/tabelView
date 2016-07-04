//
//  DataStructure.swift
//  Poll_binary
//
//  Created by Shruthi on 1/07/2016.
//  Copyright © 2016 Shruthi. All rights reserved.
//

import Foundation

typealias JSON_DATA = [String: AnyObject]

//MARK:- Poll Data structure
//
struct PollData {
    var title          : String
    var btnTitle1      : String
    var btnTitle2      : String
    var selectedOpt    : Int
    
    init(title:String, btnTitle1:String, btnTitle2:String) {
        self.title         = title
        self.btnTitle1     = btnTitle1
        self.btnTitle2     = btnTitle2
        self.selectedOpt   = -1
    }
}

struct PollTable_DS {
    var tableData:[PollData] = []
    
    init?(withJSON_Data:JSON_DATA) {
        
        guard let
            data = withJSON_Data["Poll_Data"] as? [JSON_DATA]
            else {
                debugPrint("Poll table data is empty")
                return nil
        }
        for item in data {
            guard let
                _title     = item["title"] as? String,
                _btn1Title = item["btn1Title"] as? String,
                _btn2Title = item["btn2Title"] as? String
                
                else {
                    debugPrint("cell fields are empty")
                    return nil
            }
            
            let _cellData = PollData(title: _title, btnTitle1: _btn1Title, btnTitle2: _btn2Title)
            tableData.append(_cellData)
            
        }
        
    }
    
}



import UIKit

//MARK:- Poll cell
//
class PollCell: UITableViewCell {
    var callBack: ((Int) -> ())?
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var viewContainer : UIView!
    @IBOutlet weak var lblQuestion   : UILabel!

    @IBAction func btn1Pressed(sender: UIButton) {
        callBack?(1)
    }
    
    @IBAction func btn2Pressed(sender: UIButton) {
        callBack?(2)
    }
    
}

//From Omniloop
//MARK: extend uicolor to create color from hexstring and hex RGB values
//
extension UIColor{
    static func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
        
    }
    
    
    /**
     A convenience method to create a UIColor from a hex value
     - Parameters:
     - hex: The hexadecimal value prefixed with an 0x
     - alpha: (Optional) The transparency of the color
     - Returns: a UIColor object that can be used in the code
     */
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red     = CGFloat((hex & 0xFF0000)  >> 16) / 255.0
        let green   = CGFloat((hex & 0xFF00)    >> 8) / 255.0
        let blue    = CGFloat((hex & 0xFF))          / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    /**
     Returns a lighter color by the provided percentage
     
     - Parameters:
     - percent: lighting percent percentage
     - Returns: lighter UIColor
     */
    func lighterColor(percent : Double) -> UIColor {
        return colorWithBrightnessFactor(CGFloat(1 + percent));
    }
    
    /**
     Returns a darker color by the provided percentage
     
     - parameters:
     - percent: darking percent percentage
     - returns: darker UIColor
     */
    func darkerColor(percent : Double) -> UIColor {
        return colorWithBrightnessFactor(CGFloat(1 - percent));
    }
    
    /**
     Return a modified color using the brightness factor provided
     
     - parameters:
     - factor: brightness factor
     - returns: modified color
     */
    func colorWithBrightnessFactor(factor: CGFloat) -> UIColor {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
        } else {
            return self;
        }
    }
    
}









