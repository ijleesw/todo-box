//
//  Todo.swift
//  Todo Box
//
//  Created by penguin on 27/01/2019.
//  Copyright © 2019 penguin. All rights reserved.
//

import Foundation

func getDatesFrom1970(UTC: Int = 9) -> Int
{
    let cal = NSCalendar(identifier:NSCalendar.Identifier.gregorian)!
    let now = Date(timeIntervalSinceNow: Double(3600*UTC))
    let ref1970 = Date(timeIntervalSince1970: 0)
    
    let cpnts = cal.components([.day], from: ref1970, to: now, options: [])
    return cpnts.day!
}

struct Todo
{
    var todo: String
    var dueDate: Int  // 1970-01-01부터 며칠 지났는지를 저장. 1970-01-01이면 0으로 기록됨.
    var isComplete: Bool
//    var timeComplete: Date
    
    init(todo: String, remDays: Int, isComplete: Bool = false)
    {
        self.todo = todo
        self.dueDate = getDatesFrom1970() + remDays
        self.isComplete = isComplete
//        self.timeComplete = Date()
    }
    
    init(todo: String, dueDate: Int, isComplete: Bool = false)
    {
        self.todo = todo
        self.dueDate = dueDate
        self.isComplete = isComplete
        //        self.timeComplete = Date()
    }
}
