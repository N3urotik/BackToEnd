//
//  ViewController.swift
//  BackToEnd
//
//  Created by Neurotik on 06/03/2019.
//  Copyright © 2019 Neurotik. All rights reserved.
//

import UIKit
import Foundation


//DECODE JSON FORMAT IN SWIFT FORMAT
struct Welcome: Codable {
    let nearestAirportResource: NearestAirportResource
    
    enum CodingKeys: String, CodingKey {
        case nearestAirportResource = "NearestAirportResource"
    }
}

struct NearestAirportResource: Codable {
    let airports: Airports
    let meta: Meta
    
    enum CodingKeys: String, CodingKey {
        case airports = "Airports"
        case meta = "Meta"
    }
}

struct Airports: Codable {
    let airport: [Airport]
    
    enum CodingKeys: String, CodingKey {
        case airport = "Airport"
    }
}

struct Airport: Codable {
    let airportCode: String
    let position: Position
    let cityCode, countryCode, locationType: String
    let names: Names
    let distance: Distance
    
    enum CodingKeys: String, CodingKey {
        case airportCode = "AirportCode"
        case position = "Position"
        case cityCode = "CityCode"
        case countryCode = "CountryCode"
        case locationType = "LocationType"
        case names = "Names"
        case distance = "Distance"
    }
}

struct Distance: Codable {
    let value: Int
    let uom: String
    
    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case uom = "UOM"
    }
}

struct Names: Codable {
    let name: [Name]
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
    }
}

struct Name: Codable {
    let languageCode, empty: String
    
    enum CodingKeys: String, CodingKey {
        case languageCode = "@LanguageCode"
        case empty = "$"
    }
}

struct Position: Codable {
    let coordinate: Coordinate
    
    enum CodingKeys: String, CodingKey {
        case coordinate = "Coordinate"
    }
}

struct Coordinate: Codable {
    let latitude, longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "Latitude"
        case longitude = "Longitude"
    }
}

struct Meta: Codable {
    let version: String
    let link: [Link]
    
    enum CodingKeys: String, CodingKey {
        case version = "@Version"
        case link = "Link"
    }
}

struct Link: Codable {
    let href: String
    let rel: String
    
    enum CodingKeys: String, CodingKey {
        case href = "@Href"
        case rel = "@Rel"
    }
}

//ENDED DECODE


let jsonStringData = "Nearest Airport".data(using: .utf8)!
let decoder = JSONDecoder()

class ViewController: UIViewController {
    
    @IBOutlet weak var latitudine: UITextField!
    
    @IBOutlet weak var longitudine: UITextField!
    
    @IBAction func cerca(_ sender: Any) {
        NearestAirport()
    }
    @IBOutlet weak var label: UILabel!
    
    
    @IBOutlet weak var myButton: UIButton!
    
    
    func NearestAirport(){
        
        //DECLARE API LINK IN THE RIGHT FORMAT
        let endpoint = "https://api.lufthansa.com/v1/references/airports/nearest/\(latitudine.text!),\(longitudine.text!)"
        //CHECK IF THE FORMAT IS CORRECTLY FORMATTED
        guard let url = URL(string: endpoint) else {
            print("Url not valid")
            exit(1)
        }
        let token = "x8ncz7wwcke4n3bsvp5b4yxn"
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            // check for any errors
            guard error == nil else {
                print("Error in the GET call")
                print(error!)
                return
            }
            
            // make sure we got data
            guard let responseData = data else {
                print("Error: Data not received")
                return
            }
            
            // check the status code
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: API doesn't answer")
                return
            }
            
            
            // Reponse status
            print("TEST: \(responseData)")
            print("Response status code: \(httpResponse.statusCode)")
            print("Response status debugDescription: \(httpResponse.debugDescription)")
            print("Response status localizedString: \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")
            
            // parse the result as JSON, since that's what the API provides
            do {
                
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("non riesco a convertire il file JSON")
                        return
                }
                print(todo.description)
                let richiamo = try JSONDecoder().decode(Welcome.self, from: responseData)
                DispatchQueue.main.async { // Correct
                    self.label.text = ("The airport code is \(richiamo.nearestAirportResource.airports.airport[0].airportCode) and the distance is \(richiamo.nearestAirportResource.airports.airport[0].distance.value) \(richiamo.nearestAirportResource.airports.airport[0].distance.uom)")
                }
                print("AIRPORT CODE: ")
                print(richiamo.nearestAirportResource.airports.airport[0].airportCode)
                print("AIRPORT NAME: ")
                print(richiamo.nearestAirportResource.airports.airport[0].names.name[3])
                print("DISTANCE: ")
                print(richiamo.nearestAirportResource.airports.airport[0].distance.value)
                print("\(richiamo.nearestAirportResource.airports.airport[0].distance.uom)\n")
                
                // now we have the todo
                // let's just print it to prove we can access it
                //print("The todo is: " + todo.description)
                
                // the todo object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
                guard let todoTitle = todo["title"] as? String else {
                    print("Could not get todo title from JSON")
//                    print("responseData: \(String(data: responseData, encoding: String.Encoding.utf8))")
                    return
                }
                print("The title is: " + todoTitle)
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            
            
        }
        dataTask.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view, typically from a nib.
    }
}
