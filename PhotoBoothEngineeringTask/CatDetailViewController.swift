//
//  File.swift
//  PhotoBoothEngineeringTask
//
//  Created by Imran Muhammad on 11/21/22.
//

import Foundation
import UIKit
import SDWebImage

class CatDetailViewController: UIViewController {
    
    var cat: Cat?
    let imageView = UIImageView()
    let saysTextField = UITextField()
    let applyButton = UIButton(type: .roundedRect)
    let loadingImageView = SDAnimatedImageView()
    let shareButton = UIButton(type: .roundedRect)
    
    convenience init(cat: Cat) {
        self.init(nibName: nil, bundle: nil)
        self.cat = cat
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(imageView)
        saysTextField.placeholder = "Says?"
        saysTextField.borderStyle = .roundedRect
        self.view.addSubview(saysTextField)
        
        applyButton.setTitle("Apply", for: .normal)
        self.view.addSubview(applyButton)
        self.applyButton.addTarget(self, action: #selector(self.didTapApplyButton), for: .touchUpInside)
        
        self.view.addSubview(loadingImageView)
        self.imageView.contentMode = .scaleAspectFit
        
        let animatedImage = SDAnimatedImage(named: "activity_indicator.gif")
        self.loadingImageView.image = animatedImage
        
        self.shareButton.setTitle("Share", for: .normal)
        self.shareButton.addTarget(self, action: #selector(self.shareImage), for: .touchUpInside)
        shareButton.backgroundColor = .clear
        shareButton.layer.cornerRadius = 5
        shareButton.layer.borderWidth = 1
        shareButton.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(self.shareButton)
        
        self.setConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let urlString = self.cat?.urlString else {return}
        self.setImage(urlString: urlString)
    }
    
    func setConstraints() {
        self.applyButton.translatesAutoresizingMaskIntoConstraints = false
        self.applyButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.applyButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        self.applyButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.applyButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        
        self.saysTextField.translatesAutoresizingMaskIntoConstraints = false
        self.saysTextField.heightAnchor.constraint(equalTo: self.applyButton.heightAnchor).isActive = true
        self.saysTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        self.saysTextField.trailingAnchor.constraint(equalTo: self.applyButton.leadingAnchor, constant: -10).isActive = true
        self.saysTextField.bottomAnchor.constraint(equalTo: self.applyButton.bottomAnchor).isActive = true
        
        self.shareButton.translatesAutoresizingMaskIntoConstraints = false
        self.shareButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.shareButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
        self.shareButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        self.shareButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        self.imageView.topAnchor.constraint(equalTo: self.saysTextField.bottomAnchor, constant: 10).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: self.shareButton.bottomAnchor, constant: -20).isActive = true
        
        self.loadingImageView.translatesAutoresizingMaskIntoConstraints = false
        self.loadingImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.loadingImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.loadingImageView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        self.loadingImageView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
    }
    
    func setImage(urlString: String) {
        SDWebImageDownloader.shared.config.downloadTimeout = 100
        DispatchQueue.main.async {
            let width = self.view.frame.width - 10
            let imgUrlString = self.configureImageUrl(urlString: urlString, width: width, height: width)
            let url = URL(string: imgUrlString)
            self.loadingImageView.isHidden = false
            self.imageView.isHidden = true
        
            self.imageView.sd_setImage(with: url) { image, Error, cacheType, url in
            
                self.imageView.image = image
                self.loadingImageView.isHidden = true
                self.imageView.isHidden = false
            }
        }
    }
    
    @objc func didTapApplyButton() {
        guard let text = self.saysTextField.text, let cat = self.cat else {return}
        ApiClient.shared.getCatDetail(cat: cat, says: text) { result in
            switch result {
                case .success(let newCat):
                    self.cat = newCat
                    if let urlString = newCat.urlString {
                        self.setImage(urlString: urlString)
                    }
                case .failure(let error):
                    return
            }
        }
    }
    
    func configureImageUrl(urlString: String, width: CGFloat, height: CGFloat) -> String {
        return urlString + "?&w=\(width==0.0 ? 150 : width)&h=\(height==0.0 ? 150 : height)"
    }
    
    @objc func shareImage() {
        guard let urlString = self.cat?.urlString else {return}
        guard let image = self.imageView.image, let url = URL(string: urlString) else { return }
        let data = ["Text, Image and url", image, url] as [Any]
        UIApplication.share(data)
    }
}
