//
//  UVIndexViewController.swift
//  WieCa
//
//  Created by IndratS on 16/04/19.
//  Copyright © 2019 IndratS. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire

class UVIndexViewController: UIViewController, CLLocationManagerDelegate {
    
    var receiveDataFromMenu:String = ""
    
    var WEATHER_URL = ""
    //let UVI_URL = "http://api.openweathermap.org/data/2.5/uvi"
    let APP_ID = "98623cb043652236d793d9ca6e5fbc35"
    
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lonLabel: UILabel!
    
    @IBOutlet weak var uvIndexImage: UIImageView!
    
    @IBOutlet weak var prosesButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    
    
    let locationManager = CLLocationManager()
    let uviDataModel = UVIDataModel()
    let BA = BeatifullyAll()
    lazy var geocoder = CLGeocoder()
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BA.drawingButtonBorder(data: prosesButton)
     
        //backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.setBackgroundImage(UIImage(named: "back"), for: .normal)
        
        clearAll()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        //locationManager.requestWhenInUseAuthorization()
        WEATHER_URL = receiveDataFromMenu
        
        print("===============================")
        print("ini data dari screen 1 : \(receiveDataFromMenu)")
        print("===============================")
        

        

        // Do any additional setup after loading the view.
    }
    
    //MARK: - location manager - success
    /*****
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            print("long : \(location.coordinate.longitude)")
            print("lat : \(location.coordinate.latitude)")
            
            let longitude = String(location.coordinate.longitude)
            let latitide = String(location.coordinate.latitude)
            
            let params : [String : String] = ["appid":APP_ID, "lon" : longitude, "lat":latitide]
            print("params : \(params)")
            
            // getData(url: receiveDataFromMenu, parameter: params)
            getData(url: WEATHER_URL, parameter: params)
        }
    }
    */
    
    //MARK: - location manager - error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "LOCATION UNAVAILABLE"
    }
    
    //MARK: - getData
    func getData(url: String, parameter:[String : String]){
        
        Alamofire.request(url, method:.get, parameters:parameter).responseJSON{
            respone in
            if respone.result.isSuccess{
                print("Connection Success")
                let uviDataJSON : JSON = JSON(respone.result.value!)
                //print("Data Json nya : \(uviDataJSON)")
                self.updateUVIData(json: uviDataJSON)
                
            }else if respone.result.isFailure{
                print("Connection Failed")
                print("issues is : \(String(describing: respone.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    //MARK: - updateUVIDATA
    func updateUVIData(json: JSON){
        uviDataModel.long = json["lon"].stringValue
        uviDataModel.lat = json["lat"].stringValue
        uviDataModel.dateUVI = json["date_iso"].stringValue
        uviDataModel.valueUVI = json["value"].doubleValue
        uviDataModel.uviIconName = uviDataModel.updateUVIIcon(valueUVI: uviDataModel.valueUVI)
        uviDataModel.country = countryTextField.text!
        uviDataModel.city = cityNameTextField.text!
        uviDataModel.street = streetTextField.text!
        
        print(json)
        //print("data url yang baru : \(receiveDataFromMenu)")
        
        
        updateUIDataUVI()
        
    }
    
    func updateUIDataUVI(){
        //lonLabel.text = " \(uviDataModel.long)"
        //latLabel.text = " \(uviDataModel.lat)"
        
        cityLabel.text = "\(uviDataModel.country)"
        latLabel.text = "\(uviDataModel.city)"
        lonLabel.text = "\(uviDataModel.street)"
        
        dateLabel.text = " \(uviDataModel.dateUVI)"
        
        let abc = uviDataModel.uviIconName
        print(abc)
        uvIndexImage.isHidden = false
        uvIndexImage.image = UIImage(named: uviDataModel.uviIconName)
    }
    
    
    @IBAction func prosesButtonPressed(_ sender: UIButton) {
        
        guard let country = countryTextField.text else { return }
        guard let street = streetTextField.text else { return }
        guard let city = cityNameTextField.text else { return }
        
        let alert = UIAlertController(title: "Error", message: "Please type County Name", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
                self.clearAll()
        }
        ))
        
        if country == "" {
            self.present(alert, animated: true, completion: nil)
        }else{
        let address = ("\(country),\(city), \(street)")
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
        
        
        prosesButton.isHidden = true
        //activityIndicatorView.startAnimating()
        
        }
        
    }
    

    func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?){
        prosesButton.isHidden = false
        //activityIndicatorView.stopAnimating()
        
        if let error = error {
            print("waduhhh error... (\(error))")
            
            clearAll()
            uvIndexImage.isHidden = false
            uvIndexImage.image = UIImage(named: "unavailable")
            
            
            
        }else{
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
                
                let longitude = String(location!.coordinate.longitude)
                let latitude = String(location!.coordinate.latitude)
                let params: [String : String] = ["appid":APP_ID, "lon":longitude, "lat":latitude]
                
                getData(url: WEATHER_URL, parameter: params)
                //print("url dari func proses respone : \(WEATHER_URL)")
                //print("lokasi : \(location)")
            }
            
            if let location = location {
                let coordinate = location.coordinate
                cityLabel.text = "\(coordinate.latitude), \(coordinate.longitude)"
            }else{
                cityLabel.text = "No matching"
            }
        }
        
    }
    
    
    func clearAll(){
        countryTextField.text = ""
        cityNameTextField.text = ""
        streetTextField.text = ""
        
        dateLabel.text = ""
        cityLabel.text = ""
        latLabel.text = ""
        lonLabel.text = ""
        uvIndexImage.isHidden = true
    }
    
    
    
    
    
    
    

}
