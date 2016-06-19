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
    
    var place : Int!
    
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
    
    @IBAction func SwipeRight(sender: UISwipeGestureRecognizer) {
    
        print("swipe right")
        
//        print("new article is \(place + 1)")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("idArticleViewController") as! ArticleViewController
        
        print("vc = \(vc)")
        print("presenting:")
        
        self.presentViewController(vc, animated: false, completion: {() -> Void in
            
            print((self.presentedViewController as! ArticleViewController).message)
            
            var newVC = self.presentedViewController as! ArticleViewController
            
            newVC.message = ["category":"Test","title":"Test","dc:creator":"test","pubDate":"test","currentPlace":"0","content:encoded":"this is a test"]
            
            newVC.update()
            
        })
        self.dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    @IBAction func SwipeLeft(sender: UISwipeGestureRecognizer) {
    
        print("swipe left")
        
//        print("new article is \(place - 1)")
    
    }
    
    
    @IBAction func returnFromArticleAction(sender: AnyObject) {
        self.performSegueWithIdentifier("FromArticleUnwind", sender: self)
    }
    
    func update() {
        
        //        print("CurrentPlace is \(message["currentPlace"])")
        //        print("CurrentPlace INT is \(Int(message["currentPlace"]!))")
        
//        print(self.message)
        print(message)
        
        SectionTitle.text = message["category"]
        Headline.text = message["title"]
        Byline.text = (message["dc:creator"]! as NSString).substringFromIndex(3)
        PublishDate.text = message["pubDate"]
        
        place = Int(message["currentPlace"]!)!
        
        //let dateArr = message["pubDate"]!.characters.split{$0 == " "}.map(String.init)
        
        //PublishDate.text = dateArr[0] + " " + dateArr[1] + " " + dateArr[2] + " " + dateArr[3]
        
        
        let attrStr = try! NSMutableAttributedString(
            data: message["content:encoded"]!.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        
        Article.attributedText = attrStr
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.update()
        
    }

}
