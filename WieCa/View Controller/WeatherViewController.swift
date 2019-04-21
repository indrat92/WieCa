//
//  WeatherViewController.swift
//  WieCa
//
//  Created by IndratS on 21/04/19.
//  Copyright © 2019 IndratS. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    var receiveDataFromMenu:String = ""
    
    
    @IBOutlet weak var inputCountryTextField: UITextField!
    @IBOutlet weak var inputCityTextField: UITextField!
    @IBOutlet weak var statusConnectionLabel: UILabel!
    @IBOutlet weak var prosesButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    @IBOutlet weak var countryAndCityResult: UILabel!
    @IBOutlet weak var longResult: UILabel!
    @IBOutlet weak var latResult: UILabel!
    @IBOutlet weak var temperaturResult: UILabel!
    @IBOutlet weak var pressureResult: UILabel!
    @IBOutlet weak var humidityResult: UILabel!
    
    @IBOutlet weak var resultAllStack: UIStackView!
    
    
    var WEATHER_URL = ""
    let APP_ID = "98623cb043652236d793d9ca6e5fbc35"
    let locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    
    let uviDataModel = UVIDataModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("data dari menu : \(receiveDataFromMenu)")
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        
        WEATHER_URL = receiveDataFromMenu
        
        resultAllStack.isHidden = true
        statusConnectionLabel.text = ""
        
        // back button
        //backButton.setImage(UIImage(named: "back"), for: .normal)
        
    }
    
    // koneki gagal
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error location : \(error)")
        statusConnectionLabel.text = "LOCATION UNAVAILABLE"
    }
    
    
    // ambil data dari textfiel
    @IBAction func processButtonPressed(_ sender: UIButton) {
        
        guard let country = inputCountryTextField.text else { return }
        guard let city = inputCityTextField.text else { return }
        
        let alert = UIAlertController(title: "Error", message: "Please Type County Name !", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
            self.clearAll()
        }))
        
        if country == "" {
            self.present(alert, animated: true, completion: nil)
        }else{
            
            let address = "\(country), \(city)"
            geocoder.geocodeAddressString(address) { (placemarks, error) in
                
            // ke func proses respone
            self.processRespone(withPlacemarks: placemarks, error: error)
            }
            prosesButton.isHidden = true
        }
        
        
    }
    
    // hapus data di interface
    func clearAll(){
        inputCountryTextField.text = ""
        inputCityTextField.text = ""
        statusConnectionLabel.text = ""
        humidityResult.text = ""
        pressureResult.text = ""
        countryAndCityResult.text = ""
        temperaturResult.text = ""
        latResult.text = ""
        longResult.text = ""
    }
    
    //
    func processRespone(withPlacemarks placemarks: [CLPlacemark]?, error: Error?){
        prosesButton.isHidden = false
        
        // kalo error dihandle disini, g nemu lokasinya
        if let error = error {
            print("Error di Respone : \(error)")
            clearAll()
            statusConnectionLabel.text = "LOCATION UNAVAILABLE"
            
            
        }else{
            var location : CLLocation?
    
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
                
                let longitude = String(location!.coordinate.longitude)
                let latitude = String(location!.coordinate.latitude)
                print("long : \(longitude)")
                print("lat : \(latitude)")
                statusConnectionLabel.text = "Connected..."
                
                let params : [String : String] = ["appid" : APP_ID, "lon" : longitude, "lat" : latitude ]
                // send data params ke func getData
                getData(url: WEATHER_URL, parameter:params)
            }
            
            if let location = location {
                let coordinate = location.coordinate
                print("Gokil")
            }else{
                statusConnectionLabel.text = "No Matching Location Found"
                print("No Matching Location Found")
            }
            
        }
    }
    
    func getData(url: String, parameter:[String : String]){
        Alamofire.request(url, method:.get, parameters:parameter).responseJSON{
            respone in
            if respone.result.isSuccess {
                print("<<< respone success >>>")
                let tempResult : JSON = JSON(respone.result.value)
                print(tempResult)
        
                //update data dari json ke string
                self.updateDataJSON(json: tempResult)
            }else if respone.result.isFailure {
                let error = respone.result.error
                print("<<< Error Respone : \(error)")
                self.statusConnectionLabel.text = "Connection Issues"
            }
        }
    }
 
    func updateDataJSON(json: JSON){
        
        uviDataModel.lat = json["coord"]["lat"].stringValue
        uviDataModel.long = json["coord"]["lon"].stringValue
        
        uviDataModel.temperatur = json["main"]["temp"].doubleValue
        uviDataModel.pressure = json["main"]["pressure"].doubleValue
        uviDataModel.humidity = json["main"]["humidity"].doubleValue
        
        updateUIWeather()
        
    }
    
    func updateUIWeather(){
        
        countryAndCityResult.text = "\(inputCountryTextField.text!) - \(inputCityTextField.text!)"
        longResult.text = uviDataModel.long
        latResult.text = uviDataModel.lat
        temperaturResult.text = String(uviDataModel.temperatur)
        pressureResult.text = String(uviDataModel.pressure)
        humidityResult.text = String(uviDataModel.humidity)
        
        resultAllStack.isHidden = false
        
        
    }
    
    
    

}
