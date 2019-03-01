//
//  ViewController.swift
//  ID3
//
//  Created by Daniel Esteban Salinas Suárez on 2/26/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let records: [[String: String]] = [
        ["ganador": "Alemania", "hora": "Mañana", "tipoJuego": "Mundial",  "condicionesCancha": "Excelente",  "local": "1"],
        ["ganador": "Alemania", "hora": "Tarde",  "tipoJuego": "Olímpicos","condicionesCancha": "Buena",  "local": "1"],
        ["ganador": "Alemania", "hora": "Noche",  "tipoJuego": "Amistoso", "condicionesCancha": "Mala",  "local": "0"],
        ["ganador": "México",   "hora": "Tarde",  "tipoJuego": "Amistoso", "condicionesCancha": "Pésima",  "local": "0"],
        ["ganador": "México",   "hora": "Tarde",  "tipoJuego": "Mundial",  "condicionesCancha": "Buena",  "local": "1"],
        ["ganador": "Alemania", "hora": "Tarde",  "tipoJuego": "Olímpicos","condicionesCancha": "Excelente",  "local": "1"],
        ["ganador": "Alemania", "hora": "Tarde",  "tipoJuego": "Olímpicos","condicionesCancha": "Mala",  "local": "1"],
        ["ganador": "Alemania", "hora": "Tarde",  "tipoJuego": "Olímpicos","condicionesCancha": "Mala",  "local": "1"],
        ["ganador": "Alemania", "hora": "Mañana", "tipoJuego": "Mundial",  "condicionesCancha": "Excelente",  "local": "1"],
        ["ganador": "México",   "hora": "Tarde",  "tipoJuego": "Olímpicos","condicionesCancha": "Buena",  "local": "0"],
        ["ganador": "Alemania", "hora": "Noche",  "tipoJuego": "Amistoso", "condicionesCancha": "Mala",  "local": "0"],
        ["ganador": "México",   "hora": "Noche",  "tipoJuego": "Mundial",  "condicionesCancha": "Pésima",  "local": "1"],
        ["ganador": "México",   "hora": "Tarde",  "tipoJuego": "Mundial",  "condicionesCancha": "Buena",  "local": "1"],
        ["ganador": "Alemania", "hora": "Tarde",  "tipoJuego": "Mundial",  "condicionesCancha": "Excelente",  "local": "1"],
        ["ganador": "Alemania", "hora": "Tarde",  "tipoJuego": "Olímpicos","condicionesCancha": "Mala",  "local": "1"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            let tree = try DTBuilderID3Memory.Build(
                "ganador", from: records)
            
            let newRecord: [String: String] = ["hora": "Tarde",  "tipoJuego": "Olímpicos","condicionesCancha": "Buena",  "local": "1"]
            let prediction = try tree.search(newRecord)
            print("\n\nSuccess\n\n")
            print(tree)
            print("\nprediction: \(prediction)\n")
        } catch {
            print(DecisionTree.Exception.self)
        }
        
        
        
    }


}

