//
//  MovieTableViewCell.swift
//  MovieSearchApp
//
//  Created by Kevin Siundu on 13/06/2020.
//  Copyright © 2020 Kevin Siundu. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    static let cellIdentifier = "MovieTableViewCell"
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    static func nib() -> UINib {
        return UINib(nibName: "MovieTableViewCell", bundle: nil)
    }
    func configure(with model: Movies) {
        self.movieTitle.text = model.Title
        self.movieYear.text = model.Year
        // download contents of url of poster
        let url = model.Poster
        if let data = try? Data(contentsOf: URL(string: url)!) {
            self.moviePoster.image = UIImage(data: data)
        }
    }
}
