//
//  AboutUsViewController.swift
//  TheCircleVoice
//
//  Created by James Hovet on 3/21/16.
//  Copyright © 2016 James Hovet. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    //var message:Dictionary<String,String>!

    @IBOutlet weak var AboutUsText: UITextView!
   
    @IBOutlet weak var VersionNumberLabel: UILabel!
    
    var html : String = ""
    
    @IBAction func ReturnFromAboutUs(sender: AnyObject) {
        self.performSegueWithIdentifier("FromArticleUnwind", sender: self)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //get version number
        let nsObject: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
        let version = nsObject as! String
        
        
        html = "<h1>About Us</h1><p><strong>Introduction</strong></p><p>When <em>The Circle Voice</em>, founded by a young Walter Russell Mead, first arrived on the Groton School literary scene in 1969, it was a clear underdog to Groton’s more established sources of news at the time, <em>The Grotonian </em>and the <em>Third Form Weekly.</em> The two newspapers, despite their at-times unimpressive coverage of pertinent news and limited editorial clout, had long dominated the School’s market for strong writing. Thus, to survive, <em>The</em> <em>Circle Voice</em> (CV) had to be something different, and from its inception, it was. Led by Mead, who believed that the ultimate purpose of his paper was “to work for change,” the CV developed an anti-administration agenda, questioning the assertion—often made by the <em>Weekly </em>and <em>The</em> <em>Grotonian</em>—that everything was always well on the Circle.</p><p>In 1969, the <em>Third Form Weekly </em>ran its final issue, and a few years later, <em>The</em> <em>Grotonian </em>began a gradual but definitive movement away from reporting the news. Nowadays, the <em>Weekly is</em> a piece of Groton history long since passed, while <em>The</em> <em>Grotonian </em>has moved on to feature student works of fiction and poetry—a distinct sphere of the literary market that rarely, if ever, intersects with the CV.</p><p>Today, the CV is one of the biggest student-run organizations on campus. It prints eight to ten issues per year, with each issue ranging from eight to twelve pages. In addition, for the first time ever, the CV has its own domain, thecirclevoice.org, with a fully customizable website.</p><p><strong>Location</strong></p><p>The CV room is located in the basement of the Schoolhouse, across the former location of the Mailroom. Feel free to come by, chat, and have a cup of coffee.</p><p><strong>Nota Bene</strong></p><p>Groton School and <em>The Circle Voice</em> reserve the right to remove direct solicitations, inappropriate posts, or anything not in line with the mission of the School.</p><h2 style=\"text-align: center;\"><strong><em>The Circle Voice</em> 2015-16 Masthead</strong></h2><p style=\"text-align: center;\"><strong><em>Editors-in-Chief</em></strong></p><p style=\"text-align: center;\">Varsha Harish ’16 and Ethan Woo ’16</p><p style=\"text-align: center;\"><strong><em>Creative Director</em></strong></p><p style=\"text-align: center;\">Yanni Cho ’16</p><p style=\"text-align: center;\"><strong><em>Online Editors</em></strong></p><p style=\"text-align: center;\">Cynthia Cheng ’16 and William Sun ’16</p><p style=\"text-align: center;\"><strong><em>News Editor</em></strong></p><p style=\"text-align: center;\">Yanni Cho ’16</p><p style=\"text-align: center;\"><strong><em>Opinions Editor</em></strong></p><p style=\"text-align: center;\">Zahin Das ’16</p><p style=\"text-align: center;\"><strong><em>Features Editor</em></strong></p><p style=\"text-align: center;\">Ross Ewald ’16</p><p style=\"text-align: center;\"><strong><em>Sports Editors</em></strong></p><p style=\"text-align: center;\">Parker Banks ’16 and George Klein ’16</p><p style=\"text-align: center;\"><strong><em>Arts Editor</em></strong></p><p style=\"text-align: center;\">Candace Tong-Li ’16</p><p style=\"text-align: center;\"><strong><em>Humor Editors</em></strong></p><p style=\"text-align: center;\">Steven Anton ’16 and Nena Atkinson ’16</p><p style=\"text-align: center;\"><strong><em>Photography Editors</em></strong></p><p style=\"text-align: center;\">Allie Banks ’16 and Jessica Saunders ’16</p><p style=\"text-align: center;\"><strong><em>Assistant Online Editor</em></strong></p><p style=\"text-align: center;\">Victor Liu ’17</p><p style=\"text-align: center;\"><strong><em>Assistant News Editors</em></strong></p><p style=\"text-align: center;\">Hadley Callaway ’17, Millie Kim ’17, and Victor Liu ’17</p><p style=\"text-align: center;\"><strong><em>Assistant Opinions Editors</em></strong></p><p style=\"text-align: center;\">Rand Hough ’17, Hanna Kim ’17, and Christopher Ye ’17</p><p style=\"text-align: center;\"><strong><em>Assistant Features Editors</em></strong></p><p style=\"text-align: center;\">Zizi Kendall ’17, Jack McLaughlin ’17, and Anna Reilly ’16</p><p style=\"text-align: center;\"><strong><em>Assistant Sports Editors</em></strong></p><p style=\"text-align: center;\">Will Robbins ’16 and Delaney Tantillo ’17</p><p style=\"text-align: center;\"><strong><em>Assistant Arts Editors</em></strong></p><p style=\"text-align: center;\">Ella Anderson ’17 and Claudette Ramos ’16</p><p style=\"text-align: center;\"><strong><em>Assistant Photography Editors</em></strong></p><p style=\"text-align: center;\">Ibante Smallwood ’16 and Michael You ’16</p><p style=\"text-align: center;\"><strong><em>Staff Writers</em></strong></p><p style=\"text-align: center;\">Westby Caspersen ’17, Aram Moossavi ’17, Anna Reilly ’16, Isabella Yang ’17, and Michael You ’16</p><p style=\"text-align: center;\"><strong><em>Copy Editors</em></strong></p><p style=\"text-align: center;\">Christian Carson ’18, Annie Colloredo-Mansfeld ’18, Feild Gomila ’17, Marianne Lu ’19, Min Shin ’18, and Becky Zhang ’18</p><p style=\"text-align: center;\"><strong><em>Columnists</em></strong></p><p style=\"text-align: center;\">Rand Hough ’17, Zizi Kendall ’17, Hanna Kim ’17, Claudette Ramos ’16, and Michael Senko ’18</p><p style=\"text-align: center;\"><strong><em>Mobile Developer and Designer</em></strong></p><p style=\"text-align: center;\">James Hovet '18</p><p></p><p><strong>Feedback and bug reporting:</strong>&nbsp; James Hovet : jhovet18@groton.org</p>"

        
        let attrStr = try! NSMutableAttributedString(
            data: html.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        
        AboutUsText.attributedText = attrStr
        
        VersionNumberLabel.text = version
    }
    
}
