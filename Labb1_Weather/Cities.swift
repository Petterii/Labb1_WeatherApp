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
}
