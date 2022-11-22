//
//  ApiClient.swift
//  PhotoBoothEngineeringTask
//
//  Created by Imran Muhammad on 11/16/22.
//

import Foundation

protocol ApiClientProtocol {
    func getAllCats(skip: Int, limit: Int, onComplete: @escaping (Result<[Cat], Error>)->Void)
    func getCatDetail(cat: Cat, says: String?, onComplete: @escaping (Result<Cat, Error>)->Void)
}

class ApiClient: ApiClientProtocol {
    
    static let shared = ApiClient()
    
    struct Constants {
        static let baseUrlString = "https://cataas.com"
        static let allCatsApiUrlString = "https://cataas.com/api/cats?json=true&skip=%d&limit=%d"
        static let catDetailApiUrlString = "https://cataas.com/cat/%@"
    }
    
    func getAllCats(skip: Int, limit: Int, onComplete: @escaping (Result<[Cat], Error>)->Void) {
        let urlString = String.localizedStringWithFormat(Constants.allCatsApiUrlString, skip, limit)
        guard let url = URL(string: urlString) else {
            return
        }
        
        fetch(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    var cats = try decoder.decode([Cat].self, from: data)
                    for index in 0...cats.count-1 {
                        cats[index].urlString = Constants.baseUrlString + "/cat/" + cats[index]._id
                    }
                    onComplete(.success(cats))
                } catch {
                    onComplete(.failure(error))
                }
            case .failure(let error):
                onComplete(.failure(error))
            }
        }
    }
    
    func getCatDetail(cat: Cat, says: String?, onComplete: @escaping (Result<Cat, Error>)->Void) {
        var urlString = String.localizedStringWithFormat(Constants.catDetailApiUrlString, cat._id)
        if let says = says, let escapedString = says.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            urlString = urlString + "/says/" + escapedString
        }
        
        urlString = urlString + "?json=true"
        
        guard let url = URL(string: urlString) else {
            return
        }
        fetch(url: url) { result in
            switch result {
            case .success(let data):
                
                do {
                    let catjson = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    if let urlString = catjson?["url"] as? String {
                        var catWithUrl = cat
                        catWithUrl.urlString = Constants.baseUrlString + urlString
                        onComplete(.success(catWithUrl))
                    }
                } catch {
                    onComplete(.failure(error))
                }
            case .failure(let error):
                onComplete(.failure(error))
            }
        }
    }
    
    private func fetch(url: URL, onComplete: @escaping (Result<Data, Error>)->Void) {
        var req = URLRequest(url: url)
        req.addValue("application/json", forHTTPHeaderField: "accept")
        URLSession.shared.dataTask(with: req) { (data, response, error) in
            
            if let data = data {
                onComplete(.success(data))
            } else {
                if let error = error {
                    onComplete(.failure(error))
                }
                return
            }
        }.resume()                
    }
}

