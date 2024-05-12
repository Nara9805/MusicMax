//
//  Service.swift
//  MusicMaxx
//
//  Created by Smart Castle M1A2009 on 14.04.2024.
//

import Foundation

class Service {
    
    //sigleton
    static let shared = Service()
    
    func getMusic(string: String, completion: @escaping (Feeds?, Error?) -> ()) {
        let urlString = "https://soundcloud-scraper.p.rapidapi.com/v1/playlist/metadata"
        
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func searchMusic(searchTerm: String, completion: @escaping (SearchResult?, Error?) -> ()) {
        let urlString = "https://soundcloud-scraper.p.rapidapi.com/v1/search/tracks?term=\(searchTerm)"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func playMusic(id: Int, completion: @escaping (PlayMusicResult?, Error?) -> ()) {
        let urlString = "https://soundcloud-scraper.p.rapidapi.com/v1/track/metadata?track=\(id)"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    //https://itunes.apple.com/search?term=instagram&entity=software
    
    func getMusicList(completion: @escaping (Feeds?, Error?) -> ()) {
        let urlString = "https://soundcloud-scraper.p.rapidapi.com/v1/playlist/metadata"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping (T?, Error?) -> () ) {
        
        guard let url = URL(string: urlString) else {return}
        let headers = [
            "X-RapidAPI-Key": "4f435b732emsh8925c17328b25b0p169bffjsn072f04e29be5",
            "X-RapidAPI-Host": "soundcloud-scraper.p.rapidapi.com"
        ]
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, err) in
            
            if let err = err {
                completion(nil, err)
                return
            }
            
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON String: \(jsonString)")
            }
            
            do {
                let objects = try JSONDecoder().decode(T.self, from: data!)
                //                print("data: \(data)")
                completion(objects, nil)
            } catch {
                completion(nil, error)
                print("Failed to decode:", error)
            }
        }.resume()
    }
    
}
