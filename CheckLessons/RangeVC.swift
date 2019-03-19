//
//  RangeVC.swift
//  CheckLessons
//
//  Created by fsociety.1 on 3/19/19.
//  Copyright © 2019 fsociety.1. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct TimeRange {
    
    var timeID: String
    var startTime: String
    var endTime: String
    
    init(timeID: String, startTime: String, endTime: String) {
        self.timeID = timeID
        self.startTime = startTime
        self.endTime = endTime
    }
}

class RangeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, Loadable {
    @IBOutlet var tableView: UITableView!
    
    var getRoom = String()
    var getID = String()
    var sendTimeID = String()
    var sendDayID = String()
    var sendStartTime = String()
    var sendEndTime = String()
    var json = JSON()
    var saveData = [TimeRange]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.showLoader()
        getData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saveData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomCell
        cell.selectionStyle = .none
        cell.mainLabel.text = saveData[indexPath.row].startTime + "  -  " + saveData[indexPath.row].endTime
        return cell
    }
    
    func getData() {
        let url = "http://schedule.iitu.kz/rest/user/get_timetable_room.php?bundle_id=\(getID)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).responseJSON { response in
            switch response.result {
            case .success(_):
                self.hideLoader()
                self.json = JSON(response.value)
                self.sendDayID = String(self.getDayOfWeek())
                for (key, _) in self.json["timetable"][String(self.getDayOfWeek())] {
                    let tmpData = TimeRange(timeID: key, startTime: self.getTime(timeID: key)["startTime"]!, endTime: self.getTime(timeID: key)["endTime"]!)
                    self.saveData.append(tmpData)
                }
                self.saveData = self.saveData.sorted(by: { Int($0.timeID)! < Int($1.timeID)! })
                self.tableView.reloadData()
            case .failure(let error):
                self.hideLoaderFailure()
                print(error)
            }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendTimeID = saveData[indexPath.row].timeID
        sendStartTime = saveData[indexPath.row].startTime
        sendEndTime = saveData[indexPath.row].endTime
        self.performSegue(withIdentifier: "showLesson", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? LessonVC {
            vc.getDayID = sendDayID
            vc.getTimeID = sendTimeID
            vc.getStartTime = sendStartTime
            vc.getEndTime = sendEndTime
            vc.json = json
        }
    }
    
    func getDayOfWeek() -> Int {
        let time = Calendar.current.dateComponents([.weekday], from: Date()).weekday! - 1
        if time == 0 {
            return 7
        } else {
            return time
        }
    }
    
    func getTime(timeID: String) -> Dictionary<String, String> {
        switch timeID {
        case "1":
            return ["startTime": "8:00", "endTime": "8:50"]
        case "2":
            return ["startTime": "9:00", "endTime": "9:50"]
        case "3":
            return ["startTime": "10:00", "endTime": "10:50"]
        case "4":
            return ["startTime": "11:00", "endTime": "11:50"]
        case "5":
            return ["startTime": "12:10", "endTime": "13:00"]
        case "6":
            return ["startTime": "13:10", "endTime": "14:00"]
        case "7":
            return ["startTime": "14:10", "endTime": "15:00"]
        case "8":
            return ["startTime": "15:10", "endTime": "16:00"]
        case "9":
            return ["startTime": "16:10", "endTime": "17:00"]
        case "10":
            return ["startTime": "17:20", "endTime": "18:10"]
        case "11":
            return ["startTime": "18:30", "endTime": "19:20"]
        case "12":
            return ["startTime": "19:30", "endTime": "20:20"]
        case "13":
            return ["startTime": "20:30", "endTime": "21:20"]
        case "14":
            return ["startTime": "21:30", "endTime": "22:20"]
        default:
            return ["startTime": "", "endTime": ""]
        }
    }
}
