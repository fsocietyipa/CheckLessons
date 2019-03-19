//
//  LessonVC.swift
//  CheckLessons
//
//  Created by fsociety.1 on 3/19/19.
//  Copyright © 2019 fsociety.1. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Lessons {
    var id: String
    var subject_id: String
    var subject_type_id: String
    var block_id: String
    var teacher_id: String
    var regalia_id: String
    var appointment_id: String
    var bundle_id: String?
    var day_id: String
    var time_id: String
    
    init(id: String, subject_id: String, subject_type_id: String, block_id: String, teacher_id: String, regalia_id: String, appointment_id: String, bundle_id: String? = nil, day_id: String, time_id: String) {
        self.id = id
        self.subject_id = subject_id
        self.subject_type_id = subject_type_id
        self.block_id = block_id
        self.teacher_id = teacher_id
        self.regalia_id = regalia_id
        self.appointment_id = appointment_id
        self.bundle_id = bundle_id
        self.day_id = day_id
        self.time_id = time_id
    }
}

class LessonVC: UIViewController {
    @IBOutlet var lessonNameLabel: UILabel!
    @IBOutlet var teacherNameLabel: UILabel!
    @IBOutlet var lessonTypeLabel: UILabel!
    @IBOutlet var groupLabel: UILabel!
    @IBOutlet var timeRangeLabel: UILabel!
    
    var getTimeID = String()
    var getDayID = String()
    var getStartTime = String()
    var getEndTime = String()
    var json = JSON()
    var saveData = [Lessons]()

    override func viewDidLoad() {
        super.viewDidLoad()
        makeData()
        lessonNameLabel.text = saveData[0].subject_id
        teacherNameLabel.text = saveData[0].teacher_id
        lessonTypeLabel.text = saveData[0].subject_type_id
        self.title = saveData[0].bundle_id!
        groupLabel.text = saveData[0].block_id
        timeRangeLabel.text = getStartTime + "  -  " + getEndTime
    }
    

    func makeData() {
        let subjectID = json["subjects"][json["timetable"][getDayID][getTimeID][0]["subject_id"].string!]["subject_en"].string!
        let subjectTypeID = json["subject_types"][json["timetable"][getDayID][getTimeID][0]["subject_type_id"].string!]["subject_type_en"].string!
        let blockID = json["blocks"][json["timetable"][getDayID][getTimeID][0]["block_id"].string!]["name"].string!
        let teacherID = json["teachers"][json["timetable"][getDayID][getTimeID][0]["teacher_id"].string!]["teacher_en"].string!
        let regaliaID = json["regalias"][json["timetable"][getDayID][getTimeID][0]["regalia_id"].string!]["regalia_en"].string!
        let appointmentID = json["appointments"][json["timetable"][getDayID][getTimeID][0]["appointment_id"].string!]["appointment_en"].string!
        let bundleID = json["bundles"][json["timetable"][getDayID][getTimeID][0]["bundle_id"].string!]["0"]["name_en"].string
        let dayID = getDayID
        let timeID = getTimeID
             
        let lesson = Lessons(id: json["timetable"][getDayID][getTimeID][0]["id"].string!, subject_id: subjectID, subject_type_id: subjectTypeID, block_id: blockID, teacher_id: teacherID, regalia_id: regaliaID, appointment_id: appointmentID, bundle_id: bundleID, day_id: dayID, time_id: timeID)
        self.saveData.append(lesson)
    }
}
