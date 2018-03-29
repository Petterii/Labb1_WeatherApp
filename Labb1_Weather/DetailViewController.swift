//
//  DetailViewController.swift
//  Labb1_Weather
//
//  Created by lösen är 0000 on 2018-03-16.
//  Copyright © 2018 PT. All rights reserved.
//

import UIKit






class DetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var searchBar: UITextField!
    
    var cities : [Cities] = []
   // var places : Array<Places> = Array()
    
    @IBOutlet weak var textResult: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        

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
    //    catch{}
       
    }
    
    var searchParams : String!
    ///////// JSON stuff FROM WEBSITE    ///////////////
    @IBAction func search(_ sender: Any) {
    //    buildLocalJson()
        
        
    if let safeString = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
        
        let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?q=\(safeString)&APPID=0b097aa7c90c1fe75898c100483bfa96") {
        
        //    let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?q=\(safeString)&APPID=0b097aa7c90c1fe75898c100483bfa96") {
        JsonCommands.getCitiesFromWeb(url: url, onDone: {
            (cities) in
            // kanske inte funkar testa
            // förut self.cities = cities
            self.cities.append(cities[0])
            self.tableView.reloadData()
        })
            //self.tableview.reload()
        }
          
    }
    
    /////////////
    /// tableview stuff
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = UITableViewAutomaticDimension
        let cell = tableView.dequeueReusableCell(withIdentifier: "aCell", for: indexPath) as! MyTableViewCell
        if indexPath.section == 1 {
            cell.backgroundColor = UIColor.gray
        }
        if indexPath.section == 0 {
           //  cell.backgroundColor = UIColor
           // cell.cellImage.image =
            cell.cellCity.text = cities[indexPath.row].cityName
            cell.cellTemp.text = String(format:"%d°C", Int(cities[indexPath.row].temp))
            
        }
        
        return cell
        
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return cities.count }
        if section == 1 { return cities.count }
        return 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Saved this city \(cities[0].cityName ?? "no City").")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
