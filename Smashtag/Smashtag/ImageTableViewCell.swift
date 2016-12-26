//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by Алексей Неронов on 26.12.16.
//  Copyright © 2016 Алексей Неронов. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    var urlImage: URL? {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private func updateCell() {
        imageDetail.image = nil
        if let url = urlImage {
            indicator?.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async {
                if let imgData = NSData(contentsOf: url) {
                    DispatchQueue.main.async {
                        if url == self.urlImage {
                            self.imageDetail.image = UIImage(data: imgData as Data)
                            self.indicator.stopAnimating()
                        }
                    }
                }                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
