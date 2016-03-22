//
//  ArticleEnterUnwind.swift
//  TheCircleVoice
//
//  Created by James Hovet on 3/21/16.
//  Copyright © 2016 James Hovet. All rights reserved.
//

import UIKit

class ArticleEnterUnwind : UIStoryboardSegue {
    
    override func perform() {
        self.sourceViewController.dismissViewControllerAnimated(true, completion: nil)
    }

}

