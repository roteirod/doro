//
//  Extensions.swift
//  doro
//
//  Created by Volodymyr Davydenko on 04.05.2021.
//

import UIKit

extension UIFont {
    static func quattrocentoSansRegular(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "QuattrocentoSans", size: size)
    }
    
    static func quattrocentoSansItalic(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "QuattrocentoSans-Italic", size: size)
    }
    
    static func quattrocentoSansBold(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "QuattrocentoSans-Bold", size: size)
    }
    
    static func quattrocentoSansBoldItalic(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "QuattrocentoSans-BoldItalic", size: size)
    }
    
    private static func customFont(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        assert(font != nil, "Can't load font: \(name)")
        return font ?? UIFont.systemFont(ofSize: size)
    }
}

extension UIColor {
    class var pomoRed: UIColor {
        return UIColor(red: 201 / 255.0, green: 80 / 255.0, blue: 101 / 255.0, alpha: 1.0)
    }
    
    class var pomoRedLight: UIColor {
        return UIColor(red: 230 / 255.0, green: 136 / 255.0, blue: 158 / 255.0, alpha: 1.0)
    }
    
    class var pomoGreen: UIColor {
        return UIColor(red: 43 / 255.0, green: 158 / 255.0, blue: 125 / 255.0, alpha: 1.0)
    }
    
    class var pomoGreenLight: UIColor {
        return UIColor(red: 86 / 255.0, green: 205 / 255.0, blue: 180 / 255.0, alpha: 1.0)
    }
    
    class var pomoYellow: UIColor {
        return UIColor(red: 244 / 255.0, green: 211 / 255.0, blue: 94 / 255.0, alpha: 1.0)
    }
    
    class var pomoYellowLight: UIColor {
        return UIColor(red: 250 / 255.0, green: 235 / 255.0, blue: 151 / 255.0, alpha: 1.0)
    }
    
    class var blueGrey: UIColor {
        return UIColor(red: 139.0 / 255.0, green: 139.0 / 255.0, blue: 149.0 / 255.0, alpha: 1.0)
    }
}

enum SessionState {
    case inFocus
    case inBreak
    case completed
    case notStarted
}
