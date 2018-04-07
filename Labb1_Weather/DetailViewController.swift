//
//  DetailViewController.swift
//  Labb1_Weather
//
//  Created by lösen är 0000 on 2018-03-16.
//  Copyright © 2018 PT. All rights reserved.
//

import UIKit






class DetailViewController: UIViewController {
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var sky: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var windDeg: UILabel!
    @IBOutlet weak var seaLevel: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var barrier: UIView!
    @IBOutlet weak var searchBar: UITextField!
    
    var icons :  [String : UIImage] = [:]
    //var cities : [Cities] = []
    var city : Cities!
    
    var dynamicAnimator : UIDynamicAnimator!
    var gravity : UIGravityBehavior!
    var collision : UICollisionBehavior!
    var push : UIPushBehavior!
    var firstTime : Bool = true
    var searchParams : String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if firstTime {
            firstInit()
        }
        saveButton.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///////// JSON stuff FROM WEBSITE    ///////////////
    func buildLocalJson() {
        if let url = Bundle.main.url(forResource: "city.list", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                
                let jsonData = try decoder.decode([CityLocal].self, from: data)
                
                let searchResult = jsonData.filter({ $0.name.contains(searchBar.text!)})
                searchParams = ""
                for i in 0...searchResult.count-1 {
                    searchParams = "\(searchParams),\(searchResult[i].name)"
                    if i <= searchResult.count{
                        searchParams = "\(searchParams),"
                    }
                }
                print(searchResult)
                return
            } catch {
                print("error:\(error)")
            }
        }
    }
    
    @IBAction func search(_ sender: Any) {
        push = UIPushBehavior(items: [iconImage], mode: .instantaneous)
        push.pushDirection = CGVector(dx: 0, dy: 2)
        push.magnitude = 100
        dynamicAnimator.addBehavior(push)
        saveButton.isEnabled = true
        
        if let safeString = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            
            let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?q=\(safeString)&APPID=0b097aa7c90c1fe75898c100483bfa96") {
            
            //    let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?q=\(safeString)&APPID=0b097aa7c90c1fe75898c100483bfa96") {
            JsonCommands.getCitiesFromWeb(url: url, onDone: {
                (cities) in
                // kanske inte funkar testa
                self.city = cities[0]
                //self.cities.append(cities[0])
                self.applyInfo()
                self.viewDidLoad()
                self.saveButton.isEnabled = true
            })
           
        }
        
    }
    
    @IBAction func saveCity(_ sender: Any) {
        if let storedCities = UserDefaults.standard.string(forKey: "Cities") {
            UserDefaults.standard.set("\(storedCities),\(city.cityId)", forKey: "Cities")
        }else {
            UserDefaults.standard.set("\(city.cityId)", forKey: "Cities")
        }
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    
    func getIcon(indexPath : Int) -> UIImage? {
        if let icon = icons[city.icon] {
            return icon
        } else {
            JsonCommands.downloadImage(url: URL(string: city.icon)!,onDone:  {
                iconImage in
                self.icons[self.city.icon] = iconImage
                self.applyInfo()
            }
            )
            return nil
        }
    }
    
    func firstInit() {
        firstTime = false
        title = "N/A"
        sky.text = "N/A"
        windSpeed.text = "N/A"
        windDeg.text = "N/A"
        seaLevel.text = "N/A"
        humidity.text = "N/A"
        currentTime.text = "N/A"
        currentTemp.text = "N/A"
        
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [iconImage])
        collision = UICollisionBehavior(items: [iconImage])
        collision.addBoundary(withIdentifier: "barrier" as NSCopying, for: UIBezierPath(rect: barrier.frame))
        collision.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(gravity)
        dynamicAnimator.addBehavior(collision)
    }
    
    func applyInfo() {
        iconImage.image = getIcon(indexPath: 0)
        title = city.cityName
        sky.text = city.sky
        windSpeed.text = "Wind: \(city.wind_speed) m/s"
        windDeg.text = "Wind Deg: \(city.getDirction())"
        seaLevel.text = "Sea Level: \(city.sea_level ?? -10)"
        humidity.text = "Humidity: \(city.humidity)"
        currentTime.text = "Time: \(city.dt_txt)"
        currentTemp.text = "\(Int(city.temp))°"
    }
    
}
