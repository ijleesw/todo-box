//
//  ViewController.swift
//  Todo Box
//
//  Created by penguin on 27/01/2019.
//  Copyright © 2019 penguin. All rights reserved.
//

import UIKit

var todoList = [Todo]()

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBAction func editButtonAction(_ sender: Any)
    {
        if self.tableView.isEditing
        {
            saveData()
            self.tableView.setEditing(false, animated: true)
            editButton.title = "Edit"
        }
        else
        {
            if !todoList.isEmpty
            {
                self.tableView.setEditing(true, animated: true)
                editButton.title = "Done"
            }
        }
    }
    
    
    @IBAction func refreshButton(_ sender: Any)
    {
        let prevCount = todoList.count
        todoList = todoList.filter({ $0.isComplete == false })
        
        var alertTitle: String = ""
        
        if prevCount == 0
        {
            alertTitle = "빈둥빈둥~"
        }
        else if prevCount == todoList.count
        {
            alertTitle = "한 게 없다..."
        }
        else
        {
            alertTitle = "얏호!! " + String(prevCount - todoList.count) + "개 끝냈다!"
        }
        
        let dialog = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        dialog.addAction(action)
        self.present(dialog, animated: true, completion: nil)
        
        saveData()
        tableView.reloadData()
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
        
//        todoList.append(Todo(todo: "잠자기", remDays: -1))
//        todoList.append(Todo(todo: "밥 먹기", remDays: 0))
//        todoList.append(Todo(todo: "앱 만들기", remDays: 1))
//        todoList.append(Todo(todo: "낮잠 자기", remDays: 2))
//        todoList.append(Todo(todo: "샤워하기", remDays: 3))
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        saveData()
        tableView.reloadData()
    }
    
    
    /* 몇 줄 출력할 거니? */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return todoList.count
    }
    
    
    /* 각 cell을 어떻게 출력할 거니? */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        /* 할 일? */
        cell.textLabel?.text = todoList[indexPath.row].todo
        
        /* 언제까지 */
        let weekday = ["", "일", "월", "화", "수", "목", "금", "토", ""]
        let remDays = todoList[indexPath.row].dueDate - getDatesFrom1970()
        let targetWeek = (todoList[indexPath.row].dueDate+4) % 7 + 1
        
        if remDays < 0 {
            cell.detailTextLabel?.text = "지났따리ㅜ"
        }
        else if remDays == 0 {
            cell.detailTextLabel?.text = "오늘("+weekday[targetWeek]+")!"
        }
        else if remDays == 1 {
            cell.detailTextLabel?.text = "내일("+weekday[targetWeek]+")"
        }
        else if remDays == 2 {
            cell.detailTextLabel?.text = "모레("+weekday[targetWeek]+")"
        }
        else {
            cell.detailTextLabel?.text = "조만간"
        }
        
        /* 완료? */
        if todoList[indexPath.row].isComplete {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    
    /* edit 버튼에서 delete를 누르면 어떻게 할 거니? */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        todoList.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    
    /* 각 cell을 select하면 어떻게 할 거니? */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        todoList[indexPath.row].isComplete = !todoList[indexPath.row].isComplete
        saveData()
        tableView.reloadData()
    }
    
    
    /* 메모리에 저장하기 */
    func saveData()
    {
        let data = todoList.map {
            [
                "todo": $0.todo,
                "dueDate": $0.dueDate,
                "isComplete": $0.isComplete
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "items")
        userDefaults.synchronize()
    }
    
    
    /* 메모리에서 불러오기 */
    func loadData()
    {
        let userDefaults = UserDefaults.standard
        
        guard let data = userDefaults.object(forKey: "items") as? [[String: AnyObject]] else { return }
        
        todoList = data.map {
            let todo = $0["todo"] as? String
            let dueDate = $0["dueDate"] as? Int
            let isComplete = $0["isComplete"] as? Bool
            
            return Todo(todo: todo!, dueDate: dueDate!, isComplete: isComplete!)
        }
    }
}
