//
//  FeaturedArticleTableViewCell.swift
//  TheCircleVoice
//
//  Created by James Hovet on 6/28/16.
//  Copyright © 2016 James Hovet. All rights reserved.
//

import UIKit

class FeaturedArticleTableViewCell: UITableViewCell {

    var ArticleObject : Article!
    
    var featuredImgVar : UIImage!
    
    @IBOutlet weak var FeaturedImg: UIImageView!
    
    @IBOutlet weak var ArticleUILabel: UILabel!
    
    @IBOutlet weak var ByLineUILabel: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
