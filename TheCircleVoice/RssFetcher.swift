//
//  RssFetcher.swift
//  CV-Test
//
//  Created by James Hovet on 3/13/16.
//  Copyright © 2016 James Hovet. All rights reserved.
//

import Foundation

@objc protocol XMLParserDelegate{
    func parsingWasFinished()
}

class RssFetcher : NSObject, NSXMLParserDelegate {
    
    
    
    var arrParsedData = [Dictionary<String,String>]()
    
    var currentDataDictionary = Dictionary<String,String>()
    
    var currentElement = ""
    
    var foundCharacters = ""
    
    var delegate : XMLParserDelegate?
    
    
    //delegate stuff
    func startParsingWithContentsOfURL(rssURL : NSURL) {
        let parser = NSXMLParser(contentsOfURL: rssURL)
        parser?.delegate = self
        parser?.parse()
    }
    
    
    //assign current element to local variable
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
    }
    
    //this is so that we only get the ones we care about
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if currentElement == "title" || currentElement == "pubDate" || currentElement == "dc:creator" || currentElement == "category" || currentElement == "content:encoded" || currentElement == "description"{
            foundCharacters += string
        }
    }
    
    //for each element, add the element name and data to the array of dicts "arrParsedData"
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if !foundCharacters.isEmpty{
            currentDataDictionary[currentElement] = foundCharacters
            foundCharacters = ""
            if currentElement == "content:encoded" {
                arrParsedData.append(currentDataDictionary)
            }
            
        }
    }
    
    //delegate handling
    
    func parserDidEndDocument(parser: NSXMLParser) {
        delegate?.parsingWasFinished()
    }
    
    //error handling
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        print(parseError.description)
    }
    
    func parser(parser: NSXMLParser, validationErrorOccurred validationError: NSError) {
        print(validationError.description)
    }
    
}
