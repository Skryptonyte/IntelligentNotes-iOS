//
//  AlarmViewController.swift
//  IntelligentNotes_FinalProject
//
//  Created by Rayhan Faizel on 26/11/23.
//

import UIKit

class AlarmViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateTimePicker.minimumDate = Date()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        // Do any additional setup after loading the view.
    }
    var note: Note! = nil

    @IBAction func setAlarmAndClose(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.title = self.note.title
        content.body = self.note.content
        
        print("adding alarm")
        var dateComponents = DateComponents()
        dateComponents.hour = Calendar.current.component(.hour, from: self.dateTimePicker.date)
        dateComponents.minute = Calendar.current.component(.minute, from:self.dateTimePicker.date)
        dateComponents.day = Calendar.current.component(.day, from: self.dateTimePicker.date)
        dateComponents.month = Calendar.current.component(.month, from: self.dateTimePicker.date)

        let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents, repeats: false)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval:2.0, repeats: false)
        let uuidString = "Note-\(self.note.id)"
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)


        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [uuidString])
        notificationCenter.add(request) { (error) in
           if error != nil {
              print("Error in setting alarm")
           }
        }
        UNUserNotificationCenter.current()
        .getPendingNotificationRequests(completionHandler: { requests in
          for (index, request) in requests.enumerated() {
          print("notification: \(index) \(request.identifier) \(request.trigger)")
          }
          })
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
