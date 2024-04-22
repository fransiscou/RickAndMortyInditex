//
//  UIImageView+Extensions.swift
//  RickMortyReview
//
//  Created by Fran Sarró on 22/4/24.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
    func loadImageUsingCache(withUrl urlString : String) {
        guard let url = URL(string: urlString) else { return }
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }
        
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .medium)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard error == nil else { return }
            
            DispatchQueue.main.async {
                guard let data = data else { return }
                if let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }
        }).resume()
    }
}
