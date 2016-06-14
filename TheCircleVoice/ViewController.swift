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
    
    var sections = ["News","Opinions","Features","Sports","Arts"]
    
    var currentSection = "Home"
    
    var data = Dictionary<String,[Dictionary<String,String>]>()
    
    @IBOutlet weak var topView: UIView!
    
    // Load and Save Articles
    
    func saveArticles() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(articles, toFile: Article.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save articles...")
        }
    }
    
    func loadArticles() -> [Article]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Article.ArchiveURL.path!) as? [Article]
    }
    
    
    // MARK: Article Code
    
    var articles : [Article] = []
    
    func loadDebugArticle(){
        articles.append(Article(UID: 0, headline: "This is a Test Article", byline: "By: James Hovet '18", date: "A random Date", bodyText: "LOREM IPSUM DOLOR SIT body copy", featuredImg: nil, section: "News", summary: "Lorem ipsum dolor sit summary"))
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //assign the xml parser object to a local variable
    var xmlParser : RssFetcher!

    
    //assign rows in section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data[currentSection] != nil{
            return (data[currentSection]?.count)!
        } else {
            return 10
        }
    }
    
    //assign number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //put data into the cells
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCellWithIdentifier("Article") as! ArticleTableViewCell
        
        let currentDict = data[currentSection]![indexPath.row] as Dictionary<String,String>
        let currentArticle = Article(d: currentDict)
        
        cell.ArticleObject = currentArticle

        cell.ArticleTitle.text = currentArticle.headline
        cell.Byline.text = (currentArticle.byline as NSString).substringFromIndex(3)
        let index = currentArticle.summary.endIndex.advancedBy(-10)
        cell.ArticlePreview.text = currentArticle.summary.substringToIndex(index)
        
        
        return cell
        
    }
    
    
    //worry about getting the data from the parser
    func parsingWasFinished() {
        self.TableView.reloadData()
    }
    
    @IBOutlet weak var TableView: UITableView!
    
    
    
    func parse(section:String){
        xmlParser = RssFetcher()
        xmlParser.delegate = self
        xmlParser.arrParsedData = []
        
        var numberOfPages = 5
        
        if section == "Home"{
            URLHeader = "http://thecirclevoice.org/feed/?paged="
            numberOfPages = 5
        } else {
            URLHeader = "http://thecirclevoice.org/category/" + section + "/feed/?paged="
            numberOfPages = 2
        }
        
        for i in 1...numberOfPages{
            //URL of the CV rss feed
            
            let URL = NSURL(string: URLHeader+i.description)
            print(URL.debugDescription)
            xmlParser.startParsingWithContentsOfURL(URL!)
            print("length of arrParsedData is " + String(xmlParser.arrParsedData.count))
        }
        data[section] = xmlParser.arrParsedData
        print("wrote data to section " + section)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var tmp = loadArticles()
        
        if tmp != nil {
            articles = tmp!
        }
        
        loadDebugArticle()
        loadDebugArticle()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        //print("did load")
        parse("Home")
        
        //BACKGROUND FETCHING
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            //print("This is run on the background queue")
            
            for i in self.sections{
                self.parse(i)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //print("This is run on the main queue, after the previous code in outer block")
            })
        })
        
        
    }
    
    //prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EnterArticleFromTable" {
            let secondViewController = segue.destinationViewController as! ArticleViewController
            secondViewController.message = (sender?.ArticleObject)!.toDict()
        } else {
            
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
   
    
    
   
    @IBOutlet weak var HamburgerReturnHelperView: UIView!
    
    
    func slideOut(){
        print("topView frame is:")
        print(topView.frame)
        var HamburgerWidth = SectionColorImage.frame.width
        HamburgerWidth -= 10
        let optionsOut = UIViewAnimationOptions.CurveEaseOut
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: optionsOut, animations: {
            
            self.topView.frame = CGRect(x: HamburgerWidth, y: 0, width: UIScreen.mainScreen().bounds.width , height: UIScreen.mainScreen().bounds.height)
            
            }, completion: nil)
        isOpen = true
        TableView.allowsSelection = false
        TableView.scrollEnabled = false
        HamburgerReturnHelperView.alpha = 0.1
        print("topView frame is:")
        print(topView.frame)
    }
    
    func slideIn(){
        print("topView frame is:")
        print(topView.frame)
        let optionsIn = UIViewAnimationOptions.CurveEaseIn
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: optionsIn, animations: {
            
            self.topView.frame = CGRectMake(-4, 0, self.topView.frame.width, self.topView.frame.height)
            
            }, completion: nil)
        isOpen = false
        TableView.allowsSelection = true
        TableView.scrollEnabled = true
        HamburgerReturnHelperView.alpha = 0.0
        print("topView frame is:")
        print(topView.frame)
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
        
//        if section == "Home"{
//            URLHeader = "http://thecirclevoice.org/feed/?paged="
//        } else {
//            URLHeader = "http://thecirclevoice.org/category/" + section + "/feed/?paged="
//        }
        
//        parse(section)
        if currentSection != section{
            currentSection = section
        
            TableView.reloadData()
            //print("attempt reload data")
            TableView.setContentOffset(CGPointMake(0, 0 - TableView.contentInset.top), animated: false)
        }
        slideIn()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

