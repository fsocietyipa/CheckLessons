//
//  MakeJSON.swift
//  CheckLessons
//
//  Created by fsociety.1 on 3/20/19.
//  Copyright © 2019 fsociety.1. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

class MakeJSON {
    var dataDict = [String: Any]()
    var tmpRoom = 100
    var room = 100

    public func make() -> Bool {
        if Connectivity.isConnectedToInternet {
            for i in 1...9 {
                var tmpDict = [String: String]()
                for j in 1...15 {
                    let runLoop = CFRunLoopGetCurrent()
                    let url = "http://schedule.iitu.kz/rest/user/search.php?query=" + String(self.room) + "&count=1"
                    Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                        switch response.result {
                        case .success(_):
                            CFRunLoopStop(runLoop)
                            let value = JSON(response.value)
                            if !value["result"].isEmpty {
                                if value["result"][0]["name_en"].stringValue.count == 3 {
                                    if self.room == Int(value["result"][0]["name_en"].string!) {
                                        tmpDict[String(self.room)] = value["result"][0]["id"].string!
                                    }
                                }
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }.resume()
                    CFRunLoopRun()
                    room = tmpRoom
                    room += j
                }
                dataDict[String(i)] = tmpDict
                tmpRoom += 100
                room = tmpRoom
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dataDict, options: .prettyPrinted)
                let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] .appendingPathComponent("Rooms.json")
                try? jsonData.write(to: fileUrl)
            } catch {
                print(error.localizedDescription)
            }
            return true
        } else {
            return false
        }
        print(dataDict)
    }
}
