//
//  Status.swift
//  sowhat
//
//  Created by a on 1/22/22.
//

import Foundation

enum Status: String {
    
    case Available = "Available"
    case Busy = "Busy"
    case AtSchool = "AtSchool"
    case AtTheMovies = "At the movies"
    case AtWork = "At work"
    case BatteryAboutToDie = "Battery about to die"
    case CantTalk = "CantTalk"
    case InAMeeting = "In a meeting"
    case AtTheGym = "At the gym"
    case Sleeping = "Sleeping"
    case UrgentCallsOnly = "Urgent calls only"
    
    static var array: [Status] {
        var a: [Status] = []
        
        switch Status.Available {
        case .Available:
            a.append(.Available); fallthrough
        case .Busy:
            a.append(.Busy); fallthrough
        case .AtSchool:
            a.append(.AtSchool); fallthrough
        case .AtTheMovies:
            a.append(.AtTheMovies); fallthrough
        case .AtWork:
            a.append(.AtWork); fallthrough
        case .BatteryAboutToDie:
            a.append(.BatteryAboutToDie); fallthrough
        case .CantTalk:
            a.append(.CantTalk); fallthrough
        case .InAMeeting:
            a.append(.InAMeeting); fallthrough
        case .AtTheGym:
            a.append(.AtTheGym); fallthrough
        case .Sleeping:
            a.append(.Sleeping); fallthrough
        case .UrgentCallsOnly:
            a.append(.UrgentCallsOnly)
            return a
        }
    }
}
