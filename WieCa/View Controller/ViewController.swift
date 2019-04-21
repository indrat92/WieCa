//
//  ViewController.swift
//  WieCa
//
//  Created by IndratS on 16/04/19.
//  Copyright © 2019 IndratS. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var uvIndexButton: UIButton!
    @IBOutlet weak var weatherDataButton: UIButton!
    
    let locationManager = CLLocationManager()
    let UVIndex = UVIndexViewController()
    let BA = BeatifullyAll()
    
    var urlToNextScreen : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        BA.drawingButtonBorder(data: uvIndexButton)
        BA.drawingButtonBorder(data: weatherDataButton)
        
    }
    
    
    @IBAction func wiecaButtonPressed(_ sender: UIButton) {
        //uvButtonInit.addTarget(self, action: "goUVIndexScreen", for: .touchUpInside)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let btn:UIButton = sender as! UIButton
        
        if segue.identifier == "goUVIndexScreen" {
            let destination = segue.destination as! UVIndexViewController
            if btn.tag == 1 {
                let btnValue: String = "http://api.openweathermap.org/data/2.5/uvi"
                destination.receiveDataFromMenu = btnValue
            }
            
        }else if segue.identifier == "goToScreenWeather" {
            let destination = segue.destination as! WeatherViewController
            if btn.tag == 2 {
                let btnValue: String = "http://api.openweathermap.org/data/2.5/weather"
                destination.receiveDataFromMenu = btnValue
            }
        }
    }
    

}

