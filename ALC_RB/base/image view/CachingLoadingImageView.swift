//
//  CachingLoadingImageView.swift
//  ALC_RB
//
//  Created by ayur on 23.06.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CachingLoadingImageView : UIImageView
{
    var imageUrlString: String?
    
//    let loadingIndicator: 
    
    func loadImageWith(url: URL)
    {
        var urlString = url.absoluteString
        
        if urlString.count > 0
        {
            self.imageUrlString = urlString
            
//            let url = URL(string: urlString)
            
            image = nil
            
            if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage
            {
                self.image = imageFromCache
                return
            }
            
            URLSession.shared.dataTask(with: url)
            { (data, response, error) in
                
                if error != nil
                {
                    Print.m(error)
                }
                
                DispatchQueue.main.async
                    {
                        let imageToCache = UIImage(data: data!)
                        
                        if self.imageUrlString == urlString
                        {
                            self.image = imageToCache
                        }
                        
                        imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                }
                
                }.resume()
        }
    }
}
