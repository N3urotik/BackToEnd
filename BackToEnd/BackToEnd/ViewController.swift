//
//  ViewController.swift
//  BackToEnd
//
//  Created by Neurotik on 06/03/2019.
//  Copyright © 2019 Neurotik. All rights reserved.
//

import UIKit

struct Aeroporti:Codable {
    let aeroporti: Aeroporto
}

struct Coordinate:Codable {
    let longitudine: Double
    let latitudine: Double
}

struct Nome:Codable{
    let codLinguaggio: String
    let nomeAeroporto: String
}

struct Distanza: Codable{
    let valore: Float
    let unità: String
}

struct Aeroporto:Codable {
    let codAereo: String
    let posizione: Coordinate
    let codCittà: String
    let codStato: String
    let tipoStruttura: String
    let nomi: Nome
    let distanze: Distanza
}




let jsonStringData = "Nearest airport".data(using: .utf8)!
//let decoder = JSONDecoder()
let vicino = try JSONDecoder().decode([Aeroporti].self, from: jsonStringData)
//let vicino = try decoder.decode(Aeroporti.self, from: jsonStringData)



func AeroportoVicino(){
    let key = "t6gnvthb46ue64525naf6cbp"
    var input:Coordinate = Coordinate.init(longitudine: 38.193, latitudine: 15.552)
    let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
    
//    curl -H "Authorization: Bearer t6gnvthb46ue64525naf6cbp" -H "Accept: application/json"
    
    let endpoint = "https://api.lufthansa.com/v1/references/airports/nearest/\(input)?lang=it&appid=\(key)"
    
    let safeUrlString = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    
    guard let endPointUrl = URL(string: safeUrlString!) else {
        print("Url non valido")
        return
    }
}

class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        AeroportoVicino()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

