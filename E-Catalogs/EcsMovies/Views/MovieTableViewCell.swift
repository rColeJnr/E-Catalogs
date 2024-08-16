//
//  MovieTableViewCell.swift
//  E-Catalogs
//
//  Created by rColeJnr on 13/08/24.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet var movieTitle: UILabel!
    
    @IBOutlet var overview: UILabel!
    
    @IBOutlet var movieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        overview.adjustsFontForContentSizeCategory = true
        movieTitle.adjustsFontForContentSizeCategory = true
    }
}
