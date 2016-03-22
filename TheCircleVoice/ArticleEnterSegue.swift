//
//  EnterArticleFromTable.swift
//  TheCircleVoice
//
//  Created by James Hovet on 3/21/16.
//  Copyright © 2016 James Hovet. All rights reserved.
//
import UIKit


class ArticleEnterSeque: UIStoryboardSegue {
    
    override func perform() {
        print("Custom Segue Code Excecuted")
        self.sourceViewController.presentViewController(self.destinationViewController as UIViewController,
            animated: true,
            completion: nil)
    }
    
}
