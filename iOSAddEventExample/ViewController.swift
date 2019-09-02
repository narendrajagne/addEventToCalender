//
//  ViewController.swift
//  iOSAddEventExample
//
//  Created by NK Jagne on 02/09/19.
//  Copyright © 2019 Narendra Jagne. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1
        let eventStore = EKEventStore()
        // 2
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            insertEvent(store: eventStore)
        case .denied:
            print("Access denied")
        case .notDetermined:
            // 3
            eventStore.requestAccess(to: .event, completion:
                {[weak self] (granted: Bool, error: Error?) -> Void in
                    if granted {
                        self!.insertEvent(store: eventStore)
                    } else {
                        print("Access denied")
                    }
            })
        default:
            print("Case default")
        }
    }

    func insertEvent(store: EKEventStore) {
    
        let event:EKEvent = EKEvent(eventStore: store)
        let startDate = Date()
        // 2 hours
        let endDate = startDate.addingTimeInterval(2 * 60 * 60)
        event.title = "Test Title"
        event.startDate = startDate
        event.endDate = endDate
        event.notes = "This is a note"
        event.calendar = store.defaultCalendarForNewEvents
        do {
            try store.save(event, span: .thisEvent)
        } catch let error as NSError {
            print("failed to save event with error : \(error)")
        }
        print("Saved Event")
    }
}

