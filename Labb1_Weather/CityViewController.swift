//
//  CityViewController.swift
//  Labb1_Weather
//
//  Created by lösen är 0000 on 2018-03-28.
//  Copyright © 2018 PT. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {

    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var skyInfo: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var windDegrees: UILabel!
    @IBOutlet weak var seaLevel: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var currenttime: UILabel!
    @IBOutlet weak var day1: UILabel!
    @IBOutlet weak var day2: UILabel!
    @IBOutlet weak var day3: UILabel!
    @IBOutlet weak var day4: UILabel!
    @IBOutlet weak var day5: UILabel!
    @IBOutlet weak var day1Temp: UILabel!
    @IBOutlet weak var day2Temp: UILabel!
    @IBOutlet weak var day3Temp: UILabel!
    @IBOutlet weak var day4Temp: UILabel!
    @IBOutlet weak var day5Temp: UILabel!
    
    
    
    var cities : [Cities] = []
    var id : Int = -1
     var icons :  [String : UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getJson()
        
   
        
        title = "LONDON!"
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        applyInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getJson() {
        if let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?id=\(id)&APPID=0b097aa7c90c1fe75898c100483bfa96") {
            
            JsonCommands.getCitiesFromWeb(url: url, onDone: {
                (cities) in
                self.cities = cities
           // self.applyInfo()
                self.viewDidAppear(true)
            })
        }
        

        
    }

    func applyInfo() {
        iconImage.image = getIcon(indexPath: 0)
        title = cities[0].cityName
        skyInfo.text = cities[0].sky
        windSpeed.text = "Wind: \(cities[0].wind_speed) m/s"
        windDegrees.text = "Wind Deg: \(cities[0].wind_deg ?? -10)°"
        seaLevel.text = "Sea Level: \(cities[0].sea_level ?? -10)"
        humidity.text = "Humidity: \(cities[0].humidity)"
        currenttime.text = "Time: \(cities[0].dt_txt)"
        
        //cities[0].dt_txt.removeFirst(10)
        
        day1.text = cities[0].getHours()
        day2.text = cities[1].getHours()
        day3.text = cities[2].getHours()
        day4.text = cities[3].getHours()
        day5.text = cities[4].getHours()
        day1Temp.text = "\(Int(cities[0].temp))°C"
        day2Temp.text = "\(Int(cities[1].temp))°C"
        day3Temp.text = "\(Int(cities[2].temp))°C"
        day4Temp.text = "\(Int(cities[3].temp))°C"
        day5Temp.text = "\(Int(cities[4].temp))°C"
        
    }
    
    func getIcon(indexPath : Int) -> UIImage? {
        if let icon = icons[cities[indexPath].icon] {
            return icon
        } else {
            JsonCommands.downloadImage(url: URL(string: cities[indexPath].icon)!,onDone:  {
                iconImage in
                self.icons[self.cities[indexPath].icon] = iconImage
                self.viewDidLoad()
            }
            )
            
            return nil
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
