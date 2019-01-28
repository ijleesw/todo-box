//
//  AddTodo.swift
//  Todo Box
//
//  Created by penguin on 27/01/2019.
//  Copyright © 2019 penguin. All rights reserved.
//

import UIKit

class AddTodo: UIViewController {
    let weekday = ["", "일", "월", "화", "수", "목", "금", "토", ""]
    
    @IBOutlet weak var todayDesc: UILabel!
    @IBOutlet weak var remainingDays: UITextField!
    @IBOutlet weak var whatToDo: UITextField!
    
    @IBAction func doneButton(_ sender: Any)
    {
        guard remainingDays.text != "" && whatToDo.text != "" else
        {
            // raise error
            return
        }
        
        let item: Todo = Todo(todo: whatToDo.text!, remDays: Int(remainingDays.text!)!)
        todoList.append(item)
        todoList.sort(by: { $0.dueDate < $1.dueDate })
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let cal = Calendar(identifier: .gregorian)
        let now = Date()
        let cpnts = cal.dateComponents([.month, .day, .weekday], from: now)
        
        todayDesc.text = "오늘은 " + String(cpnts.month!) + "/" + String(cpnts.day!) + "(" + String(weekday[cpnts.weekday!]) + ")!"
        
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
