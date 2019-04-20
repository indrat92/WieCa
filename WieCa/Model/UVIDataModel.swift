//
//  UVIDataModel.swift
//  WieCa
//
//  Created by IndratS on 16/04/19.
//  Copyright © 2019 IndratS. All rights reserved.
//

import Foundation

class UVIDataModel {
    
    var long: String = ""
    var lat: String = ""
    var dateUVI: String = ""
    var valueUVI: Double = 0
    var uviIconName: String = ""
    var country: String = ""
    var city : String = ""
    var street : String = ""
    
    
    func updateUVIIcon(valueUVI: Double)-> String {
        switch valueUVI {
        case 0...2.9 :
            return "IndeksLow" // low green
        case 3...5.9 :
            return "IndeksModerate" // moderate yellow
        case 6...7.9 :
            return "IndeksHigh" // high orange
        case 8...10.9 :
            return "IndeksVeryHigh" // very high red
        case 11... :
            return "IndeksExtreme" // extreme violet
        default:
            return "IndeksError"
        }
    }
    
    
    
}
