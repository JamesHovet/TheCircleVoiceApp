//
//  ArticleViewController.swift
//  TheCircleVoice
//
//  Created by James Hovet on 3/21/16.
//  Copyright © 2016 James Hovet. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController, UIScrollViewDelegate {
    
    var message:Dictionary<String,String>!
    
    var articleMessage : Article!
    
    @IBOutlet var subview: UIView!
    
    @IBOutlet weak var FeaturedImgView: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        subview = UIView()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.message = ["category":"NOT FOUND","title":"NOT FOUND","dc:creator":"NOT FOUND","pubDate":"NOT FOUND","currentPlace":"0","content:encoded":"NOT FOUND"]
    }
    
    convenience init(initMessage:Dictionary<String,String>){
        self.init()
        self.message = initMessage
    }
    
    //get data from segue
    
    
    var place : Int!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    @IBOutlet weak var HeaderHelperView: UIView!
    
    @IBOutlet weak var SectionTitle: UILabel!
    
    @IBOutlet weak var Headline: UILabel!
    
    @IBOutlet weak var Byline: UILabel!
    
    @IBOutlet weak var PublishDate: UILabel!
   
    @IBOutlet weak var ArticleTextView: UITextView!
    
    @IBOutlet weak var CaptionLabel: UILabel!
    
    @IBOutlet weak var CreditLabel: UILabel!
    
    func displayShareSheet(shareContent:NSURL) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {})
    }
    
    @IBAction func shareButtonPressed(sender: UITapGestureRecognizer){
        
        displayShareSheet(NSURL(string: message["link"]!)!)
        
    }
    
    @IBAction func SwipeRight(sender: UISwipeGestureRecognizer) {
        
        swipe(true)
        
    }
    
    @IBAction func SwipeLeft(sender: UISwipeGestureRecognizer) {
        
        swipe(false)

    }
    
    func swipe(isRight:Bool){
        
        var newPlace : Int
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        var x : CGFloat
        let y : CGFloat = 0.0
        
        var dx : CGFloat
        let dy : CGFloat = 0.0
        
        let animTime : Double = 0.3
        
        if isRight == true{
//            print("swipe right")
            newPlace = self.place - 1
            x = -screenWidth
            dx = screenWidth
            
            
        } else {
//            print("swipe left")
            newPlace = self.place + 1
            x = screenWidth
            dx = -screenWidth
        }
        
        
        
//        print("presentingVC : \(presentingViewController)")
        
        //        print(self.place)
        
        let parentVC = presentingViewController as! ViewController
        
        if newPlace == -1 || newPlace >= parentVC.articles[parentVC.currentSection]!.count {
            return
        }
        
        
        //        print(parentVC.articles)
        
        //        print(parentVC.articles[parentVC.currentSection]![self.place].toDict())
        //        print(parentVC.articles[parentVC.currentSection]![self.place + 1].toDict())
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("idArticleViewController") as! ArticleViewController
        
        vc.message = parentVC.articles[parentVC.currentSection]![newPlace].toDict()
        vc.articleMessage = parentVC.articles[parentVC.currentSection]![newPlace]
        
        
        
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(vc.view, aboveSubview: self.view)
        
        
        let firstVCView = self.view
        let secondVCView = vc.view
        
        secondVCView.frame = CGRectMake(x, y, screenWidth, screenHeight)
        
        UIView.animateWithDuration(animTime, animations: { () -> Void in
            firstVCView.frame = CGRectOffset(firstVCView.frame, dx, dy)
            secondVCView.frame = CGRectOffset(secondVCView.frame, dx, dy)
        })  { (Finished) -> Void in
//            print("FINISHED ANIM")
            
            self.dismissViewControllerAnimated(false, completion: { () -> Void in
//                print("completion: dismissing VC")
            })
            
            
            //        vc.message = ["category":"Test01","title":"Test","dc:creator":"test","pubDate":"test","currentPlace":"0","content:encoded":"this is a test","link":"http://google.com"]
            
            
            parentVC.presentViewController(vc, animated: false, completion: {() -> Void in
                
//                print("updating vc")
                vc.update()
//                print("completion: presenting VC")
                
                
            })
            
        }
        
        
        
        

    }
    
    
    @IBAction func returnFromArticleAction(sender: AnyObject) {
        self.performSegueWithIdentifier("FromArticleUnwind", sender: self)
    }
    
    func update() {
        
        SectionTitle.text = articleMessage.section
        Headline.text = articleMessage.headline
        Byline.text = (articleMessage.byline as NSString).substringFromIndex(3)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        let newDate = dateFormatter.dateFromString(message["pubDate"]!)
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        let convertedDate = dateFormatter.stringFromDate(newDate!)
        
        PublishDate.text = convertedDate
        
        place = Int(articleMessage.currentPlace)
        
        //let dateArr = message["pubDate"]!.characters.split{$0 == " "}.map(String.init)
        
        //PublishDate.text = dateArr[0] + " " + dateArr[1] + " " + dateArr[2] + " " + dateArr[3]
        
        let returned = bodyTextConverter.convertToAttributedString(articleMessage.bodyText)
        
        ArticleTextView.attributedText = returned.0
    }
    
    override var description: String {
        if self.Headline != nil{
            return "ArticleVC with Article title: \(self.Headline.text)"
        } else {
            return "ArticleVC with Article title nil"
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
//        print(self.Article.attributedText.string)
//        print(self.Article.attributedText.attributesAtIndex(0, effectiveRange: nil))
//        FeaturedImgView.contentMode = UIViewContentMode.ScaleAspectFit
        
        //TEST CODE
        
        var CVfeaturedImg = articleMessage.CVFeaturedImg
        
        
        FeaturedImgView.image = CVfeaturedImg!.image
        
        if CVfeaturedImg!.alt == "NIL ALT" {
            CaptionLabel.text = nil
            CreditLabel.text = nil
        } else {
            CaptionLabel.text = CVfeaturedImg!.alt
            CreditLabel.text = CVfeaturedImg!.credit
        }
        
        print("from ArticleVC: \(CVfeaturedImg!.alt)")
        print("from ArticleVC: \(CVfeaturedImg!.credit)")
        
        FeaturedImgView.autoresizingMask = .FlexibleHeight
        
        /*
        print(FeaturedImgView.frame)
        print(FeaturedImgView.image?.size)
        print(FeaturedImgView.image?.scale)
        print(FeaturedImgView.superview?.description)
        print(FeaturedImgView.superview?.frame)
        */
        
        self.update()
        
//        print("aboutToAppear: \(self.place)")
        
    }
    
}
