//
//  NetworkServices.swift
//  SpaceX
//
//  Created by Константин Кнор on 28.10.2022.
//

import Foundation
import UIKit

struct InfoAboutRocket: Decodable {
    let height: MetersAndFeet
    let diameter: MetersAndFeet
    let mass: Mass
    let payload_weights: [Mass]
    let first_stage: FirstStageDetails
    let second_stage: FirstStageDetails
    let flickr_images: [String]
    let name: String
    let cost_per_launch: Int
    let first_flight: String
    let country: String
    let id: String
}

struct FirstStageDetails: Decodable {
    let engines: Int
    let fuel_amount_tons: Double
    let burn_time_sec: Double?
}

struct MetersAndFeet: Codable {
    let meters: Double
    let feet: Double
}
struct Mass: Codable {
    let kg: Int
    let lb: Int
}

class NetworkServices {
    
    public enum jsonErrors: Error {
        case failedToInfoAboutRocket
    }
    
    //static let shared = NetworkServices()
    
    public func jsonRequest(completion: @escaping (Result< [InfoAboutRocket],Error>) -> Void){
        
        let urlString = "https://api.spacexdata.com/v4/rockets"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url, completionHandler:  { data, request, error in
            guard let data = data, error == nil else {
                completion(.failure(NetworkServices.jsonErrors.failedToInfoAboutRocket))
                return
            }
            do{
                let result = try JSONDecoder().decode([InfoAboutRocket].self, from: data)
                completion(.success(result))
                
            } catch {
                print("Failed to decode data")
            }

        }).resume()
    }
    
    
    public func downloadImages(with array: [InfoAboutRocket], copmpletion: @escaping ([UIImage]) -> Void){
        var arrayOfImages: [UIImage] = []
        for i in 0...3 {
            switch i {
            case 0:
                arrayOfImages.append(UIImage(named: "Falcon1") ?? UIImage())
            case 1...3:
                let countLinks = array[i].flickr_images.count - 1
                let random = Int.random(in: 0...countLinks)
                let urlString = array[i].flickr_images[random]
                guard let url = URL(string: urlString) else {
                    print("Ошибка url")
                    return }
                    URLSession.shared.dataTask(with: url) { data, responce, error in
                        guard let data = data, error == nil else {
                            print("Ошибка в запросе")
                            return arrayOfImages.append(UIImage(named: "Falcon1") ?? UIImage())
                        }
                        DispatchQueue.main.async {
                                guard let image = UIImage(data: data) else {
                                    print("Ошибка присвоении UIImage")
                                    return }
                                arrayOfImages.append(image)
                            if arrayOfImages.count == 4 {
                                copmpletion(arrayOfImages)
                            }
                        }
                    }.resume()
            default:
                arrayOfImages = []
            }
        }
       
    }
}
