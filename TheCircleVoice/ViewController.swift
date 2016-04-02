//
//  ViewController.swift
//  TheCircleVoice
//
//  Created by James Hovet on 3/21/16.
//  Copyright © 2016 James Hovet. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, XMLParserDelegate {
    
    var URLHeader:String = "http://thecirclevoice.org/feed/?paged="
    
    @IBOutlet weak var SectionColorImage: UIImageView!
    
//    var sections = ["home","news","Opinions","Features","Sports","Arts"]
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //assign the xml parser object to a local variable
    var xmlParser : RssFetcher!

    
    //assign rows in section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xmlParser.arrParsedData.count
    }
    //assign number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //put data into the cells
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCellWithIdentifier("Article") as! ArticleTableViewCell
        
        let currentDict = xmlParser.arrParsedData[indexPath.row] as Dictionary<String,String>
        
        cell.ArticleData = currentDict

        cell.ArticleTitle.text = currentDict["title"]
        cell.Byline.text = (currentDict["dc:creator"]! as NSString).substringFromIndex(3)
        let index = currentDict["description"]?.endIndex.advancedBy(-10)
        cell.ArticlePreview.text = currentDict["description"]!.substringToIndex(index!)
        
        
        return cell
        
    }
    
    
    //worry about getting the data from the parser
    func parsingWasFinished() {
        self.TableView.reloadData()
    }
    
    @IBOutlet weak var TableView: UITableView!
    
    func parse(){
        xmlParser = RssFetcher()
        xmlParser.delegate = self
        xmlParser.arrParsedData = []
        for i in 1...5{
            //URL of the CV rss feed
            let URL = NSURL(string: URLHeader+i.description)
            print(URL.debugDescription)
            xmlParser.startParsingWithContentsOfURL(URL!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("did load")
        parse()
    }
    
    //prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EnterArticleFromTable" {
            let secondViewController = segue.destinationViewController as! ArticleViewController
            secondViewController.message = sender?.ArticleData
        }
    }
    
    //return from segue
    
    @IBAction func returnFromSegueActions(sender : UIStoryboardSegue){
        self.topView.frame = CGRect(x: 0, y: 0, width: self.topView.frame.width, height: self.topView.frame.height)
    }

    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        if let id = identifier{
            if id == "idFirstSegueUnwind" {
                let unwindSegue = ArticleEnterUnwind(identifier: id, source: fromViewController, destination: toViewController, performHandler: { () -> Void in
                    
                })
                return unwindSegue
            }
        }
        
        return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)!
    }

    //hamburger code
    
    var isOpen:Bool = false
   
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var HamburgerReturnHelperView: UIView!
    
    func slideOut(){
        var HamburgerWidth = SectionColorImage.frame.width
        HamburgerWidth -= 10
        let optionsOut = UIViewAnimationOptions.CurveEaseOut
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: optionsOut, animations: {
            
            self.topView.frame = CGRect(x: HamburgerWidth, y: 0, width: self.topView.frame.width, height: self.topView.frame.height)
            
            }, completion: nil)
        isOpen = true
        TableView.allowsSelection = false
        TableView.scrollEnabled = false
        HamburgerReturnHelperView.alpha = 0.1
    }
    
    func slideIn(){
        let optionsIn = UIViewAnimationOptions.CurveEaseIn
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: optionsIn, animations: {
            
            self.topView.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
            
            }, completion: nil)
        isOpen = false
        TableView.allowsSelection = true
        TableView.scrollEnabled = true
        HamburgerReturnHelperView.alpha = 0.0
    }
    
    @IBAction func HamburgerActivated(sender: AnyObject?) {
        
        print("hamburger activated")
        print(sender.debugDescription)
        
        if sender is UISwipeGestureRecognizer{
            
            if isOpen == false && sender?.direction == UISwipeGestureRecognizerDirection.Right{
                slideOut()
            } else if isOpen == true && sender?.direction == UISwipeGestureRecognizerDirection.Left{
                slideIn()
            }
            
        } else {
            
            if isOpen == false{
                slideOut()
            } else {
                slideIn()
            }
            
        }
    }
    
    @IBAction func ActivateSwitchSection(sender: UIButton) {
        switchSection((sender.titleLabel?.text)!)
    }
    
    //section switching code
    
    
    
    func switchSection(section:String){
        
        if section == "Home"{
            URLHeader = "http://thecirclevoice.org/feed/?paged="
        } else {
            URLHeader = "http://thecirclevoice.org/category/" + section + "/feed/?paged="
        }
        
        parse()
        
        TableView.reloadData()
        print("attempt reload data")
        TableView.contentOffset = CGPointMake(0, 0 - TableView.contentInset.top);
        slideIn()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

