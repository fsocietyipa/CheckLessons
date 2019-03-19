//
//  RoomVC.swift
//  CheckLessons
//
//  Created by fsociety.1 on 3/19/19.
//  Copyright © 2019 fsociety.1. All rights reserved.
//

import UIKit
import SwiftyJSON

class RoomVC: UIViewController, UITableViewDelegate, UITableViewDataSource, Loadable {
    
    var roomsDict = [String: String]()
    var getFloor = String()
    var sendRoom = String()
    var sendID = String()
    
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.showLoader()
        self.loadData()
    }
    
    func loadData() {
        let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] .appendingPathComponent("Rooms.json")
        let data = try? Data(contentsOf: fileUrl)
        guard let result = data else { return }
        let json = JSON(result)
        for (key, value) in json[getFloor] {
            roomsDict[key] = value.string!
        }
        self.hideLoader()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomsDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomCell
        cell.selectionStyle = .none
        cell.mainLabel.text = Array(roomsDict.keys).sorted()[indexPath.row] + " room"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendRoom = Array(roomsDict.keys).sorted()[indexPath.row]
        sendID = roomsDict[sendRoom]!
        performSegue(withIdentifier: "showRange", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RangeVC {
            vc.getRoom = sendRoom
            vc.getID = sendID
        }
    }
    
}
