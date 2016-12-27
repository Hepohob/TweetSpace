//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Aleksei Neronov on 27.12.16.
//  Copyright © 2016 Aleksei Neronov. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    private var imageView = UIImageView()
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.3
            scrollView.maximumZoomScale = 5.0
        }
    }
    
    var image: UIImage? {
        didSet {
            imageView.image = image
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            autoZoomed = true
            zoomScaleToFit()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }

    //MARK: UIScrollView delegates
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        autoZoomed = false
    }

    private var autoZoomed = true
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        zoomScaleToFit()
    }
    
    private func zoomScaleToFit()
    {
        if !autoZoomed {
            return
        }
        if let sv = scrollView , image != nil && (imageView.bounds.size.width > 0)
            && (scrollView.bounds.size.width > 0){
            
            let widthRatio = scrollView.bounds.size.width  / imageView.bounds.size.width
            let heightRatio = scrollView.bounds.size.height / self.imageView.bounds.size.height
            sv.zoomScale = (widthRatio > heightRatio) ? widthRatio : heightRatio
            sv.contentOffset = CGPoint(x: (imageView.frame.size.width - sv.frame.size.width) / 2,
                                       y: (imageView.frame.size.height - sv.frame.size.height) / 2)
        }
    }

}
