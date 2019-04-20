//
//  ViewController.swift
//  WieCa
//
//  Created by IndratS on 16/04/19.
//  Copyright © 2019 IndratS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var uvIndexButton: UIButton!
    @IBOutlet weak var weatherDataButton: UIButton!
    
    let UVIndex = UVIndexViewController()
    let BA = BeatifullyAll()
    
    var urlToNextScreen : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BA.drawingButtonBorder(data: uvIndexButton)
        BA.drawingButtonBorder(data: weatherDataButton)
        
    }
    
    
    @IBAction func wiecaButtonPressed(_ sender: UIButton) {
        //uvButtonInit.addTarget(self, action: "goUVIndexScreen", for: .touchUpInside)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goUVIndexScreen" {
            let destination = segue.destination as! UVIndexViewController
            
            
            let btn:UIButton = sender as! UIButton
            if btn.tag == 1 {
                let btnValue: String = "http://api.openweathermap.org/data/2.5/uvi"
                destination.receiveDataFromMenu = btnValue
            }else if btn.tag == 2 {
                let btnValue: String = "http://api.openweathermap.org/data/2.5/weather"
                destination.receiveDataFromMenu = btnValue
            }
           
        }
    }
    
//    func drawingButton(){
//        uvIndexButton.backgroundColor = .clear
//        uvIndexButton.layer.cornerRadius = 10
//        uvIndexButton.layer.borderWidth = 2
//        uvIndexButton.layer.borderColor = UIColor.black.cgColor
//
//        weatherDataButton.backgroundColor = .clear
//        weatherDataButton.layer.cornerRadius = 10
//        weatherDataButton.layer.borderWidth = 2
//        weatherDataButton.layer.borderColor = UIColor.black.cgColor
//
//    }
    
    
    
    
    

}

