//
//  ViewController.swift
//  BackToEnd
//
//  Created by Neurotik on 06/03/2019.
//  Copyright © 2019 Neurotik. All rights reserved.
//

import UIKit
import Foundation
public struct Airports:Codable {
    let airports: [Airport]
}

public struct Coordinate:Codable {
    let Latitude: Double
    let Longitude: Double
}

public struct Name:Codable{
    let @LanguageCode: String
    let `$`: String
}

public struct Distance: Codable{
    let Value: Float
    let UOM: String
}

public struct Airport:Codable {
    let AirportCode: String
    let Position: Coordinate
    let CityCode: String
    let CountryCode: String
    let LocationType: String
    let Names: Name
    let Distance: Distance
}




let jsonStringData = "Nearest Airport".data(using: .utf8)!
let decoder = JSONDecoder()
let airports = try decoder.decode(Airports.self, from: jsonStringData)

class ViewController: UIViewController {

    func AeroportoVicino(){
        
        //DICHIARAZIONE LINK API CON RELATIVA CHIAVE
        let session = URLSession(configuration: URLSessionConfiguration.default,
                                 delegate: nil, delegateQueue: OperationQueue.main)
        let endpoint = "https://api.lufthansa.com/v1/references/airports/nearest/38.500,11.000"
        let safeUrlString = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let endpointURL = URL(string: safeUrlString!) else {
            print("Url non valido")
            return
        }
        let key = "3xwxrgw6f9jtqwy77refs3dd"
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "GET"
        request.addValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let jsonData = data else { }
            print("Non ho decodificato")
            return
            let decoder = JSONDecoder()
            do {
                let airports = try decoder.decode(Airports.self, from: jsonData)
                print("JSON decoded")
                //USE THE LOADED DATA HERE
            } catch let error {
                print(" JSON decoding failed")
            }
        }
        dataTask.resume()
    }
    
    //    @IBOutlet weak var myLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var input:Coordinate = Coordinate.init(longitudine: 38.193, latitudine: 15.552)
        AeroportoVicino(città: input)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
}
