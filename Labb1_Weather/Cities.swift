//
//  Cities.swift
//  Labb1_Weather
//
//  Created by lösen är 0000 on 2018-03-17.
//  Copyright © 2018 PT. All rights reserved.
//

import UIKit

class Cities: NSObject {
    let cityId : Int
    let cityName : String
    var dt_txt : String
    var sky : String
    
    private var _temp : Double = 0
    var temp : Double {
        get {
            return _temp-273.15
        }
        set {
            _temp = newValue
        }
    }
    
    
    var pressure : Float?
    var sea_level : Double?
    var grnd_level : Double?
    var humidity : Int
 
    var wind_speed : Double
    var wind_deg : Double?
    var icon : String
    
   
    init(cityName: String, temp: Double, humidity: Int, wind_speed: Double, dt_txt: String, sky: String, icon: String,cityId: Int,skyInfo: String, seaLevel: Double, windDeg: Double) {
     
        self.cityName = cityName
        _temp = temp
        self.humidity = humidity
        self.dt_txt = dt_txt
        self.wind_speed = wind_speed
        self.sky = sky
        self.icon = icon
        self.cityId = cityId
       self.sky = skyInfo
        self.sea_level = seaLevel
        self.wind_deg = windDeg
    }
    
    func getHours() -> String {
        var temp = dt_txt
        temp.removeFirst(10)
        return temp
    }
    
    func getDirction() -> String {
        
        switch Int(self.wind_deg!) {
        case 336...360: return "N"
        case 0...22: return "N"
        case 22...66: return "NE"
        case 66...111: return "E"
        case 111...156: return "SE"
        case 156...201: return "S"
        case 201...246: return "SW"
        case 246...291: return "W"
        case 291...336: return "NW"
            
        default:
         return "Oopsi"
        }
    }
    
    func whatCloths() -> String {
        
        if self.temp > 10 && self.sky.contains("rain") {
            return "Regn kläder"
        }
        else if self.temp > 17{
            return "Lätt klädd"
        }
        else if self.temp < 0 {
            return "Varma kläder"
        }
        else {
            return "Long Sleeved"
        }
        
        return ""
    }
}
