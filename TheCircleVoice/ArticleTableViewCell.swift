//
//  ArticleTableViewCell.swift
//  CV-Test
//
//  Created by James Hovet on 3/13/16.
//  Copyright © 2016 James Hovet. All rights reserved.
//

import Foundation
import UIKit

class ArticleTableViewCell : UITableViewCell {
    
    
    var ArticleObject : Article!
    
    @IBOutlet weak var ArticleTitle: UILabel!
    
    @IBOutlet weak var Byline: UILabel!
    
    @IBOutlet weak var ArticlePreview: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}