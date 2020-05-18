//
//  Styling.swift
//  Agenda
//
//  Created by Stefan Hermanus on 5/17/20.
//  Copyright © 2020 Stefan Corporation. All rights reserved.
//

import Foundation
import UIKit

class Utilities{
    
    static func bottomBorderOnly(_ textfield: UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.size.height - 1, width: textfield.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.white.cgColor
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomLine)
    }
    
}
