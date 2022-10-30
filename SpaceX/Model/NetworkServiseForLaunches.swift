//
//  NetworkServiseForLaunches.swift
//  SpaceX
//
//  Created by Константин Кнор on 30.10.2022.
//

import Foundation


struct Launches: Codable{
    let rocket: String
    let success: Bool?
    let name: String
    let date_utc: String
    let upcoming: Bool
}

class NetworkForLaunches {
    
    static let shered = NetworkForLaunches()
    
    public func getLaunches(completion: @escaping (Result<[Launches],Error>) -> Void){
        let urlString = "https://api.spacexdata.com/v4/launches"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, responce, error in
            guard let data = data, error == nil else {
                print("Failed to get launches")
                return
            }
            do{
                let result = try JSONDecoder().decode([Launches].self, from: data)
                completion(.success(result))
            } catch{
                completion(.failure(error))
            }
        }.resume()
    }
}
