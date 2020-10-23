    //
//  Gradient.swift
//  Assignment2
//
//  Created by Stephen Byatt on 14/10/20.
//  Copyright © 2020 Stephen Byatt. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override func layoutSubviews() {
        
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.8)
        let whiteColor = UIColor.white
        gradient.colors = [whiteColor.withAlphaComponent(0.0).cgColor, whiteColor.withAlphaComponent(1.0).cgColor]
        gradient.locations = [NSNumber(value: 0.0),NSNumber(value: 0.3)]
        gradient.frame = self.bounds
        self.layer.mask = gradient
        
    }
}
