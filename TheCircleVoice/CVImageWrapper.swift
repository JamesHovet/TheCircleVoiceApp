//
//  CVImageWrapper.swift
//  TheCircleVoice
//
//  Created by James Hovet on 8/7/16.
//  Copyright © 2016 James Hovet. All rights reserved.
//

import UIKit

class CVImageWrapper {

    var alt : String
    var credit : String
    var image : UIImage?
    
    init(image : UIImage?, alt : String, credit : String) {
        
        self.image = image
        self.alt = alt
        self.credit = credit
        
        //DELETE ME
//        print("from CVImageWrapper init: \(alt)")
//        print("from CVImageWrapper init: \(credit)")
//        print("\n")
        
    }
    
}
