//
//  ViewController.swift
//  Labb1_Weather
//
//  Created by lösen är 0000 on 2018-03-16.
//  Copyright © 2018 PT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var currentIcon: UIImageView!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentCity: UILabel!
    @IBOutlet weak var currentClouds: UILabel!
    @IBOutlet weak var currentWind: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentId : Int = -1
    var cities : [Cities] = []
    var cityNames : String = ""
    var icons :  [String : UIImage] = [:]
    
    var clothsNow : String = ""
    
    
    var dynamicAnimator : UIDynamicAnimator!
    var gravity : UIGravityBehavior!
    var collision : UICollisionBehavior!
    var push : UIPushBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [currentWind])
        collision = UICollisionBehavior(items: [currentWind,tableView])
        collision.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(gravity)
        dynamicAnimator.addBehavior(collision)
        
        
        
        //  UserDefaults.standard.removeObject(forKey: "Cities")
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func whatCloths() {
        var weatherNow : String = ""
        
        switch (weatherNow) {
        case "rain": clothsNow = "Rain Jacket"
        case "snow": clothsNow = "Fat Jacket"
        case "cold": clothsNow = "Warm Cloths"
        case "hot": clothsNow = "take of t-short"
        case "cool": clothsNow = "t-short"
            
        default:
            clothsNow = "Tshirt"
        }
            
        
        
    }
    
    func jSonGet(){
        // let safeString = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
        
        if let url = URL(string: "http://api.openweathermap.org/data/2.5/group?id=\(cityNames)&APPID=0b097aa7c90c1fe75898c100483bfa96") {
            
            JsonCommands.getCitiesFromWeb(url: url, onDone: {
                (cities) in
                self.cities = cities
                self.tableView.reloadData()
            })
            
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let Names = UserDefaults.standard.string(forKey: "Cities") {
            cityNames = Names
            print("got user citijes stores defaults thingis BANG!!!")
            jSonGet()
        }
        print("I APPEARED!!!!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyTableViewCell
        if indexPath.section == 1 {
            cell.backgroundColor = UIColor.gray
            
            
        }
        if indexPath.section == 0 {
            
            
            cell.cellImage.image = getIcon(indexPath: indexPath.row)
            cell.cellCity.text = cities[indexPath.row].cityName
            cell.cellTemp.text = String(format:"%d °C", Int(cities[indexPath.row].temp))
            
        }
        
        return cell
        
    }
    
    func getIcon(indexPath : Int) -> UIImage? {
        if let icon = icons[cities[indexPath].icon] {
            return icon
        } else {
            JsonCommands.downloadImage(url: URL(string: cities[indexPath].icon)!,onDone:  {
                iconImage in
                self.icons[self.cities[indexPath].icon] = iconImage
                self.tableView.reloadData()
            }
            )
            return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cities.count
        }
        if section == 1 {
            return cities.count
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailedView" {
            let wetherFetcher: CityViewController = segue.destination as! CityViewController
            let current = currentId
            wetherFetcher.icons = icons
            wetherFetcher.id = cities[current].cityId
            // wetherFetcher.cities = cities
        }
        
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentCity.center = CGPoint(x: 0, y: 0)
        currentIcon.alpha  = 0.5
        push = UIPushBehavior(items: [currentWind], mode: .instantaneous)
        push.pushDirection = CGVector(dx: 0, dy: 2)
        push.magnitude = 60
        dynamicAnimator.addBehavior(push)
       
        UIView.beginAnimations("Current Weather View", context: nil)
        currentCity.text = cities[indexPath.row].cityName
        currentCity.center =  CGPoint(x: 10, y: 10) //
        currentIcon.alpha = 1
     
        UIView.commitAnimations()
        
        print("You tapped cell number \(indexPath.row).")
        self.currentId = indexPath.row
     
        currentIcon.image = icons[cities[indexPath.row].icon]
        currentTemp.text = String(format:"%d °C", Int(cities[indexPath.row].temp))
        currentClouds.text = cities[indexPath.row].sky
        currentWind.text = "Wind: \(cities[indexPath.row].wind_speed) m/s " // todo change light breeze to something
    }
    

    
}

