//
//  JsonCommands.swift
//  Labb1_Weather
//
//  Created by lösen är 0000 on 2018-03-20.
//  Copyright © 2018 PT. All rights reserved.
//

import UIKit


struct CityLocal : Codable {
    let id : Int
    let name : String
}

struct WindCond: Codable {
    let speed : Double
    let deg: Double?
}

struct Condition: Codable {
    let main : String
    let icon : String
    let description : String
}

struct Temp: Codable {
    let temp : Double
    let pressure : Double
    let humidity : Int
    let sea_level : Double?
}

struct Weather : Codable {
    
    let weather: [Condition]
    let wind: WindCond
    let main: Temp
    let name: String?
    let id: Int?
    let dt_txt:String?
    let dt : Int
}

struct CityInfo : Codable{
    let id : Int
    let name : String
}

struct WeatherRespons : Codable {
    let list: [Weather]
    let city: CityInfo?
}



class JsonCommands: NSObject {
    
    static func getCitiesFromWeb(url: URL, onDone : @escaping ([Cities]) -> ()) -> () {
        
        var cities : [Cities] = []
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler:
        { (data : Data?, response : URLResponse?, error : Error?) in
            if let actualError = error {
                print(actualError)
            } else {
                if let actualData = data {
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        let weatherRespons = try decoder.decode(WeatherRespons.self, from: actualData)
                        var i = 0
                        
                        repeat {
                            var cityNaaame:String = "dummy"
                            var cityIdd:Int = -1
                            var dtTime = "no Time"
                            var sea_lvl : Double = 0
                            var wind_Deg : Double = 0
                            
                            // first group check then single
                            if let cityName = weatherRespons.list[i].name, let cityId = weatherRespons.list[i].id {
                                cityNaaame = cityName
                                cityIdd = cityId
                                
                            } else if let cityName = weatherRespons.city?.name, let cityId = weatherRespons.city?.id,
                                let dtText = weatherRespons.list[i].dt_txt, let windDeg = weatherRespons.list[i].wind.deg, let seaLevel = weatherRespons.list[i].main.sea_level{
                                cityNaaame = cityName
                                cityIdd = cityId
                                dtTime = dtText
                                wind_Deg = windDeg
                                sea_lvl = seaLevel
                                
                            }
                            
                            let city : Cities = Cities(cityName: cityNaaame,
                                                       temp:weatherRespons.list[i].main.temp,
                                                       humidity: weatherRespons.list[i].main.humidity,
                                                       wind_speed: weatherRespons.list[i].wind.speed,
                                                       dt_txt: dtTime,
                                                       sky: weatherRespons.list[i].weather[0].main,
                                                       icon: String(format:"http://openweathermap.org/img/w/%@.png",
                                                                    weatherRespons.list[i].weather[0].icon) ,
                                                       cityId: cityIdd,
                                                       skyInfo: weatherRespons.list[i].weather[0].description,
                                                       seaLevel: sea_lvl,
                                                       windDeg: wind_Deg)
                            
                            
                            cities.append(city)
                            i += 1
                            
                            
                            
                        } while(i <  weatherRespons.list.count)
                        
                        DispatchQueue.main.async {
                            onDone(cities)
                        }
                    } catch let e {
                        print("Error parsing json: \(e)")
                    }
                    
                }       else {
                    print("Data was nil.")
                }
            }
        })
        
        task.resume()
    }
    
    ///// get image
    static func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    static func downloadImage(url: URL, onDone : @escaping (UIImage) -> ()) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                onDone(UIImage(data: data)!)
                
            }
        }
        
    }
    
}
