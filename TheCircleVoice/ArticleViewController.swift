//
//  ArticleViewController.swift
//  TheCircleVoice
//
//  Created by James Hovet on 3/21/16.
//  Copyright © 2016 James Hovet. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController, UIScrollViewDelegate {
    
    //get data from segue
    var message:Dictionary<String,String>!
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    @IBOutlet weak var HeaderHelperView: UIView!
    
    @IBOutlet weak var SectionTitle: UILabel!
    
    @IBOutlet weak var Headline: UILabel!
    
    @IBOutlet weak var Byline: UILabel!
    
    @IBOutlet weak var PublishDate: UILabel!
    
    @IBOutlet weak var Article: UITextView!

    func displayShareSheet(shareContent:NSURL) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {})
    }
    
    @IBAction func shareButtonPressed(sender: UITapGestureRecognizer){
        
        displayShareSheet(NSURL(string: message["link"]!)!)
        
    }
    
    @IBAction func returnFromArticleAction(sender: AnyObject) {
        self.performSegueWithIdentifier("FromArticleUnwind", sender: self)
    }
    override func viewWillAppear(animated: Bool) {
        
//        print("CurrentPlace is \(message["currentPlace"])")
//        print("CurrentPlace INT is \(Int(message["currentPlace"]!))")
        
        SectionTitle.text = message["category"]
        Headline.text = message["title"]
        Byline.text = (message["dc:creator"]! as NSString).substringFromIndex(3)
        PublishDate.text = message["pubDate"]
        
        //let dateArr = message["pubDate"]!.characters.split{$0 == " "}.map(String.init)
        
        //PublishDate.text = dateArr[0] + " " + dateArr[1] + " " + dateArr[2] + " " + dateArr[3]
        
        
        let attrStr = try! NSMutableAttributedString(
            data: message["content:encoded"]!.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        
        Article.attributedText = attrStr
    }

}
