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
        ["descuento": "sí",  "ejemplares": "<=4", "ventas": "buenas",   "precio": "<=150"],
        ["descuento": "sí",  "ejemplares": ">4",  "ventas": "buenas",   "precio": ">150"],
        ["descuento": "sí",  "ejemplares": ">4",  "ventas": "buenas",   "precio": "<=150"],
        ["descuento": "sí",  "ejemplares": "<=4", "ventas": "buenas",   "precio": ">150"],
        ["descuento": "sí",  "ejemplares": ">4",  "ventas": "buenas",   "precio": ">150"],
        ["descuento": "sí",  "ejemplares": ">4",  "ventas": "bajas",    "precio": ">150"],
        ["descuento": "no",  "ejemplares": "<=4", "ventas": "bajas",    "precio": ">150"],
        ["descuento": "sí",  "ejemplares": "<=4", "ventas": "bajas",    "precio": ">150"],
        ["descuento": "sí",  "ejemplares": ">4",  "ventas": "bajas",    "precio": "<=150"],
        ["descuento": "no",  "ejemplares": "<=4", "ventas": "bajas",    "precio": "<=150"],
        ["descuento": "no",  "ejemplares": "<=4", "ventas": "promedio", "precio": "<=150"],
        ["descuento": "no",  "ejemplares": ">4",  "ventas": "promedio", "precio": "<=150"],
        ["descuento": "sí",  "ejemplares": "<=4", "ventas": "promedio", "precio": ">150"],
        ["descuento": "sí",  "ejemplares": ">4",  "ventas": "promedio", "precio": ">150"],
        ["descuento": "no",  "ejemplares": ">4",  "ventas": "promedio", "precio": "<=150"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            let tree = try DTBuilderID3Memory.buildRecursively(
                "descuento", from: records) 
            
            //let newRecord: [String: String] = ["ejemplares": ">4",
             //                                  "ventas": "promedio",
             //                                  "precio": "<=150"]
            //let prediction = try tree.search(newRecord)
            //print(prediction)
            print("Success")
            print(tree)
        } catch {
            print(DecisionTree.Exception.self)
        }
        
        
        
    }


}

