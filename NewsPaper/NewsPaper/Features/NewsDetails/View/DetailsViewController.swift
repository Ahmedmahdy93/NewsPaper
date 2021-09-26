//
//  DetailsViewController.swift
//  NewsPaper
//
//  Created by Ahmed Mahdy on 26/09/2021.
//

import UIKit
import Kingfisher
import SafariServices

class DetailsViewController: UIViewController {
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsDescription: UITextView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var content: UITextView!
    
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        if let photo = article?.urlToImage {
            guard let url = URL(string: photo) else { return }
            newsImage.kf.setImage(with: url)
        }
        newsTitle.text = article?.title
        newsDescription.text = article?.description
        date.text = Date.getFormattedDate(string: article?.publishedAt)
        source.text = article?.source?.name
        author.text = article?.author
        content.text = article?.content
    }
    @IBAction func openSource(_ sender: Any) {
        if let url = article?.url {
            guard let url = URL(string: url) else { return }
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }
    }
}
