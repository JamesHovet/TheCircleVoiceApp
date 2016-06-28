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
    
    var sections = ["Home","News","Opinions","Features","Sports","Arts"]
    
    var currentSection = "Home"
    
    var data = Dictionary<String,[Dictionary<String,String>]>()
    
    var loadedUIDs : [Int] = [0]
    
    @IBOutlet weak var topView: UIView!
    
    var articles: [String:[Article]] = ["Home":[],"News":[],"Opinions":[],"Features":[],"Sports":[],"Arts":[]]
    
    // Load and Save Articles
    
    func saveArticles() {
        
//        print(articles)
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(articles, toFile: Article.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save articles...")
        } else {
//            print("SAVED:")
//            print(NSKeyedUnarchiver.unarchiveObjectWithFile(Article.ArchiveURL.path!) as? Dictionary<String,[Article]>)
        }
    }
    
    func saveArticles(d:Dictionary<String,[Article]>){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(d, toFile: Article.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save articles...")
        } else {
//            print("SAVED:")
//            print(NSKeyedUnarchiver.unarchiveObjectWithFile(Article.ArchiveURL.path!) as? Dictionary<String,[Article]>)
        }

    }
    
    func loadArticles() -> Dictionary<String,[Article]>? {
//        print("LOADED")
        
        let x = NSKeyedUnarchiver.unarchiveObjectWithFile(Article.ArchiveURL.path!) as? Dictionary<String,[Article]>
        
        if x == nil {
//            print("loaded Nil")
//            print(Article.ArchiveURL.path!)
        } else {
//            print("loaded NOT Nil")
        }
        
        return x
        
    }
    
    func clearArticles() {
        for i in sections{
            articles[i] = []
        }
        saveArticles()
    }
    
    // MARK: Article Code
    
    
    
    func loadDebugArticle(){
        articles["Arts"]!.append(Article(UID: 0, headline: "This is a Test Article", byline: "By: James Hovet '18", date: "A random Date", bodyText: "LOREM IPSUM DOLOR SIT body copy", featuredImg: nil, section: "News", summary: "Lorem ipsum dolor sit summary",link: "http://google.com"))
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //assign the xml parser object to a local variable
    var xmlParser : RssFetcher!

    
    //assign rows in section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if articles[currentSection] != nil{
            return articles[currentSection]!.count
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
        
        let currentArticle = articles[currentSection]![indexPath.row]
        
//        currentArticle.currentPlace = Int(indexPath.row)
//        print(currentArticle.currentPlace)
        
        let cell =  tableView.dequeueReusableCellWithIdentifier("Article") as! ArticleTableViewCell

        
        cell.ArticleObject = currentArticle

        cell.ArticleTitle.text = currentArticle.headline
        cell.Byline.text = (currentArticle.byline as NSString).substringFromIndex(3)
        let index = currentArticle.summary.endIndex.advancedBy(-10)
        cell.ArticlePreview.text = currentArticle.summary.substringToIndex(index)
        
        cell.featuredArticle = currentArticle.featuredImg
        
        return cell
        
    }
    
    
    
    //worry about getting the data from the parser
    func parsingWasFinished() {
        
        //print(Article(d:data["News"]![0]))
        
        self.TableView.reloadData()
    }
    
    @IBOutlet weak var TableView: UITableView!
    
    /* 
     adds the article to the list of articles if it is not already in the list
     returns true if the article was added
     returns false if the article was not added
    */
    
    func conditionalAppend(a:Article) -> Article? {
        if (loadedUIDs.contains(a.UID)){
//            print("Did not add")
            return nil
        } else {
//            articles["Home"]!.append(a)
//            print("did add")
            return a
        }
        
//        articles["Home"]!.append(a)
//        return true
        
    }
    
    
    func parseReturn(n:Int,startingDict:Dictionary<String,[Article]>) -> Dictionary<String,[Article]>{
        
        xmlParser = RssFetcher()
        xmlParser.delegate = self
        xmlParser.arrParsedData = []
        
        var copy = startingDict
        
        let URL = NSURL(string: URLHeader+n.description)
        print(URL.debugDescription)
        xmlParser.startParsingWithContentsOfURL(URL!)
//        print("length of arrParsedData is " + String(xmlParser.arrParsedData.count))
        
        for i in xmlParser.arrParsedData{
//            conditionalAppend(Article(d:i))
            let tmp = Article(d: i)
            
            let toAdd = conditionalAppend(tmp)
            if toAdd != nil{
                copy["Home"]!.append(toAdd!)
                if toAdd?.section != "Showcase" {
                    copy[(toAdd?.section)!]!.append(toAdd!)
                }
            }
            loadedUIDs.append(tmp.UID)
//            print(loadedUIDs)
            
        }
        
//        print("ALL ARTICLES:")
//        for i in articles{
//            print(i)
//        }
        
//        saveArticles(copy)
        
        return copy
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //clearArticles()
        
//        loadDebugArticle()
//        loadDebugArticle()
//        saveArticles()
//        
        
        saveArticles(parseReturn(1, startingDict: articles))
        
        articles = loadArticles()!
        self.getArticleIndexes()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        //print("did load")
       
        
        //BACKGROUND FETCHING
        
//        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
//        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
//        dispatch_async(backgroundQueue, {
//            //print("This is run on the background queue")
//            
//            
//            for n in 2..<11{
//                self.saveArticles(self.parseReturn(n, startingDict: self.articles))
//                self.articles = self.loadArticles()!
//                self.getArticleIndexes()
//            }
//            self.TableView.reloadData()
//            
////            print("reloaded data !!!")
//            
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                //print("This is run on the main queue, after the previous code in outer block")
//            })
//        })
        
        
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
        
        //DELETE ME:

        //END DELETE ME:
        
//        print("topView frame is:")
//        print(topView.frame)
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
//        print("topView frame is:")
//        print(topView.frame)
    }
    
    func slideIn(){
        
        
//        DELETE ME:
//        
//        
        print(articles[currentSection]![0].featuredImg)
//        
//        END DELETE ME
//        
        
        self.getArticleIndexes()

        
//        print("topView frame is:")
//        print(topView.frame)
        let optionsIn = UIViewAnimationOptions.CurveEaseIn
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: optionsIn, animations: {
            
            self.topView.frame = CGRectMake(-4, 0, self.topView.frame.width, self.topView.frame.height)
            
            }, completion: nil)
        isOpen = false
        TableView.allowsSelection = true
        TableView.scrollEnabled = true
        HamburgerReturnHelperView.alpha = 0.0
//        print("topView frame is:")
//        print(topView.frame)
    }
    
    @IBAction func HamburgerActivated(sender: AnyObject?) {
        
//        print("hamburger activated")
//        print(sender.debugDescription)
        
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
    
    func getArticleIndexes() {
        
        for i in 0..<articles[self.currentSection]!.count{
            articles[self.currentSection]![i].currentPlace = i
//            print(self.currentSection, i, articles[self.currentSection]![i])
        }
        
    }
    
    func showAboutUsViewController(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("idAboutUsViewController") as! AboutUsViewController
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func showAboutUsAction(sender: AnyObject) {
        
        showAboutUsViewController()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

