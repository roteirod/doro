//
//  Custom Slider.swift
//  doro
//
//  Created by Volodymyr Davydenko on 04.05.2021.
//

import UIKit

class CustomSlider: UISlider {
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let point = CGPoint(x: bounds.minX, y: bounds.midY)
        return CGRect(origin: point, size: CGSize(width: bounds.width, height: 7))
    }
}
