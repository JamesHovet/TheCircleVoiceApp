//
//  bodyTextConverter.swift
//  TheCircleVoice
//
//  Created by James Hovet on 6/27/16.
//  Copyright © 2016 James Hovet. All rights reserved.
//

import Foundation
import UIKit

class bodyTextConverter: NSObject{
    
    
    static func convertToAttributedString(text : String) -> (NSAttributedString,UIImage?) {
        
        let returned = extractBodyText(text)
        
        let bodyText = returned.0
        
        var downloadedImgs : [UIImage?] = []
        
        for i in returned.1{
            
            if let match = i.rangeOfString("src=\".+\" alt", options: .RegularExpressionSearch) {
                
                //                print(i[match])
                let URLString = i[Range(match.startIndex.advancedBy(5) ..< match.endIndex.advancedBy(-5))]
                
//                print(URLString)
                
                let url = NSURL(string: URLString)
                
                var img : UIImage?
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                    dispatch_async(dispatch_get_main_queue(), {img = UIImage(data: data!)});
                }
                
                
                downloadedImgs.append(img)
            }
            
        }
        
        //        print(downloadedImgs)
        
        let attrs = [NSFontAttributeName : UIFont(name: "Georgia", size: 16.0)!]
        
        let attrStr = try! NSMutableAttributedString(
            data: bodyText.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        
        attrStr.addAttributes(attrs, range: NSRange(location: 0,length: attrStr.length))
        if downloadedImgs.count != 0{
            return (attrStr,downloadedImgs[0])
        } else {
            return (attrStr,nil)
        }
        
        
    }
    
    static func convertToAttributedSummary(text : String) -> NSAttributedString {
//        let returned = extractBodyText(text)
//        print("calling convertToAttributedSummary")
        
        let summaryText = text.stringByReplacingOccurrencesOfString("JUSTIFY", withString: "LEFT", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
//        let summaryText = returned.0
        
        let attrs = [NSFontAttributeName : UIFont(name: "Georgia", size: 16.0)!]
        
        let attrStr = try! NSMutableAttributedString(
            data: summaryText.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        
        attrStr.addAttributes(attrs, range: NSRange(location: 0,length: attrStr.length))

        return attrStr
    }
    
    static func extractFeaturedImg(article : Article) -> UIImage? {
        
        let text = article.bodyText
        
        if let match = text.rangeOfString("src=\".+\" alt", options: .RegularExpressionSearch) {
            let URLString = text[Range(match.startIndex.advancedBy(5) ..< match.endIndex.advancedBy(-5))]

            let url = NSURL(string: URLString)
            
            let data = NSData(contentsOfURL: url!)
            let img = UIImage(data: data!)
//            print("img in bodyTextConverter\(img)")
            
            return img
            
        } else {
//            print("ABOUT TO RETURN NIL!")
            return nil
        }
    }
    
    static func extractImgString(text:String) ->(String?,String?) {
        if let match = text.rangeOfString("<div id=\".+</div>", options: .RegularExpressionSearch) {
            let newText = text[Range(text.startIndex ..< match.startIndex)] + text[Range(match.endIndex ..< text.endIndex)]
            
            let imgStr = text[match]
            //            print(imgStr)
            return (imgStr,newText)
            
        } else {
            return (nil,nil)
        }
        
    }
    
    
    static func extractBodyText(text:String) -> (String,[String]){
        
        var newText = text.stringByReplacingOccurrencesOfString("JUSTIFY", withString: "LEFT", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        var extractedImgStrings : [String] = []
        
        var done = false
        
        while done == false {
            
            let res = extractImgString(String(newText))
            
            if res.0 == nil {
                done = true
                break
            } else {
                newText = res.1!
                extractedImgStrings.append(res.0!)
                //                print("RES:")
                //                print(res.0)
            }
            
        }
        
//        print("extracted:\(extractedImgStrings)")
        
        return (newText,extractedImgStrings)
        
    }
    
    
}
