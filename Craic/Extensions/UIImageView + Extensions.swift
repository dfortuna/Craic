//
//  UIImageView + Extensions.swift
//  Craic
//
//  Created by Denis Fortuna on 16/12/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func load(urlString: String, callback: @escaping (Bool) -> Void)  {
        self.image = Icons.userPictureNotFound
        self.contentMode = .center
        self.tintColor = .lightGray
        if let urlImage = URL(string: urlString) {
            DispatchQueue.global().async { [weak self] in
                if let dataImage = try? Data(contentsOf: urlImage) {
                    if let image = UIImage(data: dataImage) {
                        DispatchQueue.main.async {
                            self?.image = image
                            self?.contentMode = .scaleAspectFill
                            callback(true)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        callback(false)
                    }
                }
            }
        }
    }
}

