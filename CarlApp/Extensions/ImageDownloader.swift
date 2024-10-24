//
//  UiImage.swift
//  CarlApp
//
//  Created by Felicia Alamorean on 10.10.2024.
//

import UIKit

func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data, let image = UIImage(data: data) {
            completion(image)
        } else {
            completion(nil)
        }
    }.resume()
}
