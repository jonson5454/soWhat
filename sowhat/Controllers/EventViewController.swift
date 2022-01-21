//
//  EventViewController.swift
//  sowhat
//
//  Created by a on 1/4/22.
//
//  Here we manage the Events for Calendar
//

import UIKit
import EventKit
import EventKitUI

class EventViewController: UIViewController {

    //: MARK: PROPERTIES
    let eventStore = EKEventStore()
    
    //: MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //: MARK: CALENDAR EVENT AT BACKGROUND
    func createCalendarEvent() {
                
        eventStore.requestAccess(to: .event) { [weak self] success, error in
        
            guard let store = self?.eventStore else { return }
            
            store.requestAccess(to: .event) { [weak self] success, error in
                if success, error == nil {
                    let newEvent = EKEvent(eventStore: store)
                    newEvent.title = "Hey! have you checked today's events yet?"
                    newEvent.notes = "Check out today's events and more"
                    newEvent.startDate = Date()
                    newEvent.endDate = Date()
                    newEvent.calendar = store.defaultCalendarForNewEvents
                    do {
                        try store.save(newEvent, span: .thisEvent)
                    } catch {
                        print("Error: Saving new event error!", String(describing: error))
                    }
                } else {
                    print("Error: checking permissions")
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
