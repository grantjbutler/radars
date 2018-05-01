//
//  BrokenThing.swift
//  CGFloatCoding
//
//  Created by Grant Butler on 5/1/18.
//  Copyright © 2018 Lickability. All rights reserved.
//

import UIKit

class BrokenThing: NSObject, NSCoding {
    
    let value: CGFloat
    
    init(value: CGFloat) {
        self.value = value
    }
    
    required init?(coder aDecoder: NSCoder) {
        value = CGFloat(aDecoder.decodeDouble(forKey: "Value"))
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(value, forKey: "Value")
    }
    
}
