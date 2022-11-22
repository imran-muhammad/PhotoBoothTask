//
//  CatCollectionViewCell.swift
//  PhotoBoothEngineeringTask
//
//  Created by Imran Muhammad on 11/18/22.
//

import Foundation
import UIKit
import SDWebImage

class CatCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    let loadingImageView = SDAnimatedImageView()
    var cat: Cat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(loadingImageView)
        self.contentView.layer.borderWidth = 2.0
        let animatedImage = SDAnimatedImage(named: "activity_indicator.gif")
        loadingImageView.image = animatedImage
        setImageViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        loadingImageView.translatesAutoresizingMaskIntoConstraints = false
        loadingImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        loadingImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        loadingImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loadingImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func configureWith(cat: Cat) {
        SDWebImageDownloader.shared.config.downloadTimeout = 100
        self.cat = cat
        loadingImageView.isHidden = false
        imageView.isHidden = true
        if let urlString = cat.urlString {
            guard let url = URL(string: configureImageUrl(urlString: urlString, width: self.imageView.frame.width, height: self.imageView.frame.height))
            else {
                return
            }
            imageView.sd_setImage(with: url) { image, Error, cacheType, url in
                self.imageView.image = image
                self.loadingImageView.isHidden = true
                self.imageView.isHidden = false
            }
        }
    }
    
    func configureImageUrl(urlString: String, width: CGFloat, height: CGFloat) -> String {
        return urlString + "?&w=\(width==0.0 ? 150 : width)&h=\(height==0.0 ? 150 : height)"
    }
}
