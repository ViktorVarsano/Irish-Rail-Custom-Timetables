//
//  NewsTableViewCell.swift
//  xml_Parser_project_b
//
//  Created by Viktor Varsano on 30.10.20.
//

import UIKit

enum CellState {
    case expanded
    case collapsed
}

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var descriptionLabel:UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 3
        }
    }
    @IBOutlet weak var dateLabel:UILabel!
    
    var item: RSSItem! {
        didSet {
            titleLabel.text = "From \(item.Origin) To \(item.Destination) Departured original destination at \(item.Origintime) Expected arrival at final destination \(item.Destinationtime)"
            dateLabel.text = "You are at \(item.Stationfullname) at \(item.Querytime)"
            descriptionLabel.text = "Last location \(item.Lastlocation) \(item.Status) Due In(minutes) \(item.Duein) Late(minutes) \(item.Late) Expected Departure \(item.Expdepart)"
        }
    }
}
