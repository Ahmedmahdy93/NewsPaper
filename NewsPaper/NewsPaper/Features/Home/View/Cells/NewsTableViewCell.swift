//
//  NewsTableViewCell.swift
//  NewsPaper
//
//  Created by Ahmed Mahdy on 26/09/2021.
//

import UIKit
import Kingfisher

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    
    public var article: Article? {
        didSet {
            if let photo = article?.urlToImage {
                guard let url = URL(string: photo) else { return }
                newsImage.kf.setImage(with: url)
            }
            newsTitle.text = article?.title
            source.text = article?.source?.name
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
