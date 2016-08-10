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
        
        /*
         DELETE ME:
         */
        
        extractAllImgs(article)
        
        let text = article.bodyText
        
//        print(text)
        
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
    
    static func CVextractFeaturedImg(article : Article) -> CVImageWrapper {
        
        /*
         DELETE ME:
         */
        
        let imgs = extractAllImgs(article)
        
        let text = article.bodyText
        
        //        print(text)
        
        if let match = text.rangeOfString("src=\".+\" alt", options: .RegularExpressionSearch) {
            let URLString = text[Range(match.startIndex.advancedBy(5) ..< match.endIndex.advancedBy(-5))]
            
            let url = NSURL(string: URLString)
            
            let data = NSData(contentsOfURL: url!)
            let img = UIImage(data: data!)
            //            print("img in bodyTextConverter\(img)")
            
            if imgs.endIndex != 0{
                return imgs[0]!
            }
        }
        
        return CVImageWrapper(image: nil, alt: "NIL ALT", credit: "NIL CREDIT")
        
    }
    
    static func extractAllImgs(article : Article) -> Array<CVImageWrapper?> {
        
        let text = article.bodyText
        
        var choppedText = text
        
        var arr = Array<CVImageWrapper?>()
        
        let numImgs = extractBodyText(article.bodyText).1.endIndex
        
        for i in Range(0 ..< numImgs){
            if let match = choppedText.rangeOfString("src=\".+\" alt", options: .RegularExpressionSearch) {
                let URLString = choppedText[Range(match.startIndex.advancedBy(5) ..< match.endIndex.advancedBy(-5))]
                
//                print("URL")
//                print(URLString)
                
                let url = NSURL(string: URLString)
                
                let data = NSData(contentsOfURL: url!)
                let img = UIImage(data: data!)
                //            print("img in bodyTextConverter\(img)")
                
                var altString = "NILISH ALT STRING"
                
                if let match = choppedText.rangeOfString("alt=\".+\" srcset", options: .RegularExpressionSearch) {
                    altString = choppedText[Range(match.startIndex.advancedBy(5) ..< match.endIndex.advancedBy(-8))]
//                    print("ALT")
//                    print(altString)
//                    print("img in bodyTextConverter\(img)")
//                    
                }
                
                //TODO: ADD CREDIT CODE
                
                var creditString = "NILISH CREDIT STRING"
                
                if let match = choppedText.rangeOfString("line\">.+</span>", options: .RegularExpressionSearch) {
                    creditString = choppedText[Range(match.startIndex.advancedBy(6) ..< match.endIndex.advancedBy(-7))]
                    
                    creditString = creditString.stringByReplacingOccurrencesOfString("&#8217;", withString: "'")
                    
//                    print(creditString)
                    //                    print("ALT")
                    //                    print(altString)
                    //            print("img in bodyTextConverter\(img)")
                    
                }
                
                
                var chopEnd = choppedText.endIndex
                if let match = choppedText.rangeOfString("</div>", options: .RegularExpressionSearch) {
//                    print("MATCH")
                    chopEnd = match.endIndex
                }
                
                
//                print("before")
//                print(choppedText)
                
//                print("start \(chopEnd)")
//                print("end   \(choppedText.endIndex)")
                
                choppedText = choppedText[Range(chopEnd ..< choppedText.endIndex)]
//                print("after")
//                print(choppedText)
                
                arr.append(CVImageWrapper(image: img!, alt: altString, credit: creditString))
            }
            
        }
        
        return arr
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
