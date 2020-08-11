//
//  WebAPIService.swift
//  Heady-Ecommerce
//
//  Created by Prem Budhwani on 09/08/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import Foundation
import UIKit

class WebAPIService: NSObject {
    lazy var endPoint: String = {
        return "https://stark-spire-93433.herokuapp.com/json"
    }()

    func getDataWith(completion: @escaping (Result<[String: AnyObject]>) -> Void) {
        
        let urlString = endPoint
        
        guard let url = URL(string: urlString) else { return completion(.Error("Invalid URL.")) }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
        guard error == nil else { return completion(.Error(error!.localizedDescription)) }
        guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no Items to show"))}
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                guard (json["categories"] as? [[String: AnyObject]]) != nil else {
                    return completion(.Error(error?.localizedDescription ?? "There are no Items to show"))
                }
                DispatchQueue.main.async {
                    completion(.Success(json))
                }
            }
        } catch let error {
            return completion(.Error(error.localizedDescription))
        }
        }.resume()
    }
}

enum Result<T> {
    case Success(T)
    case Error(String)
}
