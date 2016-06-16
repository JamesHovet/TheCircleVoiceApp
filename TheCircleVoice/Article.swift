//
//  Article.swift
//  TheCircleVoice
//
//  Created by James Hovet on 6/13/16.
//  Copyright © 2016 James Hovet. All rights reserved.
//

import Foundation
import UIKit

struct PropertyKey {
    static let UIDKey = "UID"
    static let headlineKey = "headline"
    static let bylineKey = "byline"
    static let dateKey = "date"
    static let bodyTextKey = "bodyText"
    static let featuredImgKey = "featuredImg"
    static let sectionKey = "section"
    static let summaryKey = "summary"
    static let linkKey = "link"
}

class Article: NSObject, NSCoding {
    
    // MARK: object variables
    
    var UID : Int
    var headline : String
    var byline : String
    var date : String
    var bodyText : String
    var featuredImg : UIImage?
    var section : String
    var summary : String
    var link : String
    var currentPlace : Int = -1
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("articles")
    
    // MARK: initializers
    
    init(UID:Int,headline:String,byline: String, date:String, bodyText: String, featuredImg : UIImage?, section: String, summary : String, link:String){
        self.UID = UID;self.headline = headline;self.byline = byline;self.date = date;self.bodyText = bodyText;self.featuredImg = featuredImg;self.section = section;self.summary = summary; self.link = link
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let UID = aDecoder.decodeIntegerForKey(PropertyKey.UIDKey)
        let headline = aDecoder.decodeObjectForKey(PropertyKey.headlineKey) as! String
        let byline = aDecoder.decodeObjectForKey(PropertyKey.bylineKey) as! String
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as! String
        let bodyText = aDecoder.decodeObjectForKey(PropertyKey.bodyTextKey) as! String
        let featuredImg = aDecoder.decodeObjectForKey(PropertyKey.featuredImgKey) as? UIImage
        let section = aDecoder.decodeObjectForKey(PropertyKey.sectionKey) as! String
        let summary = aDecoder.decodeObjectForKey(PropertyKey.summaryKey) as! String
        let link = aDecoder.decodeObjectForKey(PropertyKey.linkKey) as! String
        
//        print("initizlized Article from aCoder")
        
        self.init(UID:UID,headline: headline,byline: byline,date: date, bodyText: bodyText, featuredImg: featuredImg, section: section, summary: summary, link: link)
    }
    
    convenience init(d:Dictionary<String,String>){
        
        let URL = d["link"]!
//        print(URL)
        
//        var URL = "http://thecirclevoice.org/1254/features/a-history-of-senior-shenanigans/"
        
        var len = 4
        
        var myNSString = URL as NSString
        myNSString = myNSString.substringWithRange(NSRange(location: 29, length: len))
//        print("NSSTRING:")
//        print(myNSString)
        
        var didWork = false
        
        var UID = Int(myNSString as String)
        
        while didWork == false{
        
            UID = Int(myNSString as String)
            if UID != nil{
                didWork = true
            } else if(len < 1){
                didWork = true
                UID = -1
            } else {
                len -= 1
                myNSString = myNSString.substringWithRange(NSRange(location: 0, length: len))
            }
        
        }
        
//        print("UID:")
//        print(UID)
        
        
        
        
        let headline = d["title"]
        let byline = d["dc:creator"]
        let date = d["pubDate"]
        let bodyText = d["content:encoded"]
        let featuredImg : UIImage? = nil
        
        var linkNSString = d["link"]! as NSString
        linkNSString = linkNSString.substringFromIndex(3)
        
        let link = linkNSString as String
//        print(link)
        
        let options = [
            "\n\t\t\t\tArts" : "Arts",
            "\n\t\t\t\tFeatures" : "Features",
            "\n\t\t\t\tNews" : "News",
            "\n\t\t\t\tOpinions" : "Opinions",
            "\n\t\t\t\tSports" : "Sports",
            "\n\t\tShowcase" : "Showcase"
        ]
        
        let section = options[d["category"]!]
//        print(section)
        
        
        
        let summary = d["description"]
        
//        print("Inititalized Article from Dict")
        
        self.init(UID:UID!,headline: headline!,byline: byline!,date: date!, bodyText: bodyText!, featuredImg: featuredImg, section: section!, summary: summary!,link: link)
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(UID, forKey: PropertyKey.UIDKey)
        aCoder.encodeObject(headline, forKey: PropertyKey.headlineKey)
        aCoder.encodeObject(byline, forKey: PropertyKey.bylineKey)
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
        aCoder.encodeObject(bodyText, forKey: PropertyKey.bodyTextKey)
        aCoder.encodeObject(featuredImg, forKey: PropertyKey.featuredImgKey)
        aCoder.encodeObject(section, forKey: PropertyKey.sectionKey)
        aCoder.encodeObject(summary, forKey: PropertyKey.summaryKey)
        aCoder.encodeObject(link, forKey: PropertyKey.linkKey)
        
//        print("EncodedWithCoder")
        
    }
    
    override var description : String {
        return "\(self.UID):Article Named: \(self.headline) \n"
    }
    
    func toDict() -> Dictionary<String,String> {
        var tmp = Dictionary<String,String>()
        tmp["category"] = self.section
        tmp["title"] = self.headline
        tmp["dc:creator"] = self.byline
        tmp["pubDate"] = self.date
        tmp["content:encoded"] = self.bodyText
        tmp["link"] = self.link
        tmp["currentPlace"] = String(self.currentPlace)
        
        return tmp
    }
    
    
}