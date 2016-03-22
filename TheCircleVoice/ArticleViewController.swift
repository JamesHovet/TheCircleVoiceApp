//
//  ArticleViewController.swift
//  TheCircleVoice
//
//  Created by James Hovet on 3/21/16.
//  Copyright © 2016 James Hovet. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    
    //get data from segue
    var message:Dictionary<String,String>!
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBOutlet weak var SectionTitle: UILabel!
    
    @IBOutlet weak var Headline: UILabel!
    
    @IBOutlet weak var Byline: UILabel!
    
    @IBOutlet weak var PublishDate: UILabel!
    
    @IBOutlet weak var Article: UITextView!
    
    @IBAction func returnFromArticleAction(sender: AnyObject) {
        self.performSegueWithIdentifier("FromArticleUnwind", sender: self)
    }
    override func viewWillAppear(animated: Bool) {
        var SectionText = message["category"]
        print(SectionText)
        if SectionText == "\n\t\tShowcase" {
            SectionText = "Showcase"
        } else if SectionText == "\n\t\t\t\tOpinions" {
            SectionText = "Opinions"
        } else if SectionText == "\n\t\t\t\tNews" {
            SectionText = "News"
        } else {
            SectionText = (SectionText! as NSString).substringFromIndex(5)
        }
        SectionTitle.text = SectionText
        //SectionTitle.text = "Sports"
        Headline.text = message["title"]
        Byline.text = (message["dc:creator"]! as NSString).substringFromIndex(3)
        //PublishDate.text = message["pubDate"]
        
        let dateArr = message["pubDate"]!.characters.split{$0 == " "}.map(String.init)
        
        PublishDate.text = dateArr[0] + " " + dateArr[1] + " " + dateArr[2] + " " + dateArr[3]
        
        
        let attrStr = try! NSMutableAttributedString(
            data: message["content:encoded"]!.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        
        Article.attributedText = attrStr
    }

}
