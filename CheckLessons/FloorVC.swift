//
//  ViewController.swift
//  CheckLessons
//
//  Created by fsociety.1 on 3/19/19.
//  Copyright © 2019 fsociety.1. All rights reserved.
//

import UIKit
import SwiftyJSON
class FloorVC: UIViewController, UITableViewDelegate, UITableViewDataSource, Loadable {

    @IBOutlet var tableView: UITableView!
    
    var floorArray = [String]()
    var sendFloor = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.loadData()
    }
    
    func loadData() {
        let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] .appendingPathComponent("Rooms.json")
        let data = try? Data(contentsOf: fileUrl)
        if data != nil {
            guard let result = data else { return }
            let json = JSON(result)
            for (key, _) in json {
                floorArray.append(key)
            }
            floorArray = floorArray.sorted()
            tableView.reloadData()
        } else {
            self.showLoader()
            if MakeJSON().make() {
                self.hideLoaderSuccess()
            } else {
                self.hideLoaderFailure()
            }
            loadData()
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return floorArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomCell
        cell.selectionStyle = .none
        cell.mainLabel.text = "\(floorArray[indexPath.row]) - floor"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendFloor = floorArray[indexPath.row]
        performSegue(withIdentifier: "showRoom", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RoomVC {
            vc.getFloor = sendFloor
        }
    }
    @IBAction func reload(_ sender: Any) {
        self.showLoader()
        if MakeJSON().make() {
            self.hideLoaderSuccess()
        } else {
            self.hideLoaderFailure()
        }
    }
}

