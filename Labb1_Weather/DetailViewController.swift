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
    
    
    
    
    
    
    @IBOutlet weak var searchBar: UITextField!
    
    var icons :  [String : UIImage] = [:]
    var cities : [Cities] = []

    
    @IBOutlet weak var textResult: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///////// JSON stuff FROM WEBSITE    ///////////////
    func buildLocalJson() {
        // var ding : CityLocal
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
    
    var searchParams : String!
 
    
    @IBAction func search(_ sender: Any) {
    if let safeString = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
        
        let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?q=\(safeString)&APPID=0b097aa7c90c1fe75898c100483bfa96") {
        
        //    let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?q=\(safeString)&APPID=0b097aa7c90c1fe75898c100483bfa96") {
        JsonCommands.getCitiesFromWeb(url: url, onDone: {
            (cities) in
            // kanske inte funkar testa
            // förut self.cities = cities
            self.cities.append(cities[0])
            self.applyInfo()
            self.viewDidLoad()
        })
            //self.tableview.reload()
        }
          
    }
    
    @IBAction func saveCity(_ sender: Any) {
        if let storedCities = UserDefaults.standard.string(forKey: "Cities") {
            print("Found nil \(cities[0].cityName).")
            UserDefaults.standard.set("\(storedCities),\(cities[0].cityId)", forKey: "Cities")
        }else {
            print("Found NOT nil \(cities[0].cityName).")
            UserDefaults.standard.set("\(cities[0].cityId)", forKey: "Cities")
            
            
        }
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    
    func getIcon(indexPath : Int) -> UIImage? {
        if let icon = icons[cities[indexPath].icon] {
            return icon
        } else {
            JsonCommands.downloadImage(url: URL(string: cities[indexPath].icon)!,onDone:  {
                iconImage in
                self.icons[self.cities[indexPath].icon] = iconImage
                self.applyInfo()
                self.viewDidLoad()
            }
            )
            
            return nil
            
        }
    }
    
    func applyInfo() {
        iconImage.image = getIcon(indexPath: 0)
        title = cities[0].cityName
        sky.text = cities[0].sky
        windSpeed.text = "Wind: \(cities[0].wind_speed) m/s"
        windDeg.text = "Wind Deg: \(cities[0].getDirction())"
        seaLevel.text = "Sea Level: \(cities[0].sea_level ?? -10)"
        humidity.text = "Humidity: \(cities[0].humidity)"
        currentTime.text = "Time: \(cities[0].dt_txt)"
        
    }

}
