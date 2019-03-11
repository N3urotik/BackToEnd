//
//  ViewController.swift
//  BackToEnd
//
//  Created by Neurotik on 06/03/2019.
//  Copyright © 2019 Neurotik. All rights reserved.
//

import UIKit
import Foundation

/*
public struct Airports: Codable {
    let airports: [Airport]
}

public struct Coordinate:Codable {
    let Latitude: Double
    let Longitude: Double
}

public struct Name:Codable{
    let LanguageCode: String
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
    let Names: [Name]
    let Distance: Distance
}

*/


let jsonStringData = "Nearest Airport".data(using: .utf8)!
let decoder = JSONDecoder()
//let airports = try decoder.decode(Airports.self, from: jsonStringData)

class ViewController: UIViewController {
    
    @IBOutlet weak var latitudine: UITextField!
    
    @IBOutlet weak var longitudine: UITextField!
    
    @IBAction func cerca(_ sender: Any) {
        AeroportoVicino()
    }
    
    
    @IBOutlet weak var myButton: UIButton!
    
    
    func AeroportoVicino(){
        
        //DICHIARAZIONE LINK API CON RELATIVA CHIAVE
        let endpoint = "https://api.lufthansa.com/v1/references/airports/nearest/\(String(describing: latitudine)),\(String(describing: longitudine))"
        //eseguo un controllo per vedere se l'url è valido
        guard let url = URL(string: endpoint) else {
            print("Url non valido")
            exit(1)
        }
        let token = "jkerurhyncwv68rnbpctk9ue"
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            // check for any errors
            guard error == nil else {
                print("Errore nella chiamata GET")
                print(error!)
                return
            }
            
            // make sure we got data
            guard let responseData = data else {
                print("Errore: Dati non ricevuti")
                return
            }
            
            // check the status code
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Errore: L' API non risponde")
                return
            }
            
            
            // Reponse status
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
                // now we have the todo
                // let's just print it to prove we can access it
                print("The todo is: " + todo.description)
                
                // the todo object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
                guard let todoTitle = todo["title"] as? String else {
                    print("Could not get todo title from JSON")
                    print("responseData: \(String(data: responseData, encoding: String.Encoding.utf8))")
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
        
        myButton.layer.cornerRadius = 50
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //@IBOutlet weak var lbl: UILabel! = Airports.airports.names[0]
    
}
