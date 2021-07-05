//
//  ViewController.swift
//  MultiTimer
//
//  Created by Дмитрий Жучков on 01.07.2021.
//

import UIKit

final class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Tableview protocol stubs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timer",for: indexPath) as! TimerCell
        if let cell = cell as? TimerCell {
          cell.time = timerArray[indexPath.row]
          cell.index = indexPath
        }

        if indexPath.row % 2 == 0 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0);
        }
        if (Int(cell.time?.time ?? "0") ?? 0 <= 0) {
        timerArray.remove(at: indexPath.row)
        timerList.deleteRows(at: [indexPath], with: .automatic)
            
        }
        print(cell.time?.time)
        cell.configure()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = timerList.cellForRow(at: indexPath) as? TimerCell {
            cell.pauseTimer()
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            timerArray.remove(at: indexPath.row)
            timerList.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    public var timerArray: [Time] = []
    
    // MARK: Elements init
    let addTimersLabel: UILabel = {
             let label = UILabel()
             label.numberOfLines = 1
             label.textColor = #colorLiteral(red: 0.7293474078, green: 0.7294713855, blue: 0.7293310761, alpha: 1)
             label.text = "Добавление таймеров"
             label.translatesAutoresizingMaskIntoConstraints = false
             return label
         }()
    let lineView: UIView = {
           let line = UIView()
           line.backgroundColor = #colorLiteral(red: 0.8940909505, green: 0.8940883279, blue: 0.898322165, alpha: 1)
           line.translatesAutoresizingMaskIntoConstraints = false
           return line
       }()
    let timersLabel: UILabel = {
             let label = UILabel()
             label.numberOfLines = 1
             label.textColor = #colorLiteral(red: 0.7293474078, green: 0.7294713855, blue: 0.7293310761, alpha: 1)
             label.text = "Таймеры"
             label.translatesAutoresizingMaskIntoConstraints = false
             return label
         }()
    let timerList: UITableView = {
             let tableView = UITableView()
             tableView.translatesAutoresizingMaskIntoConstraints = false
             tableView.register(TimerCell.self, forCellReuseIdentifier: "timer")
             return tableView
         }()
    let addButton: UIButton = {
              let add = UIButton()
              add.translatesAutoresizingMaskIntoConstraints = false
              add.setTitleColor(.link, for: .normal)
              add.setTitle("Добавить", for: .normal)
              add.layer.cornerRadius = 5
              add.layer.masksToBounds = true
              add.backgroundColor = #colorLiteral(red: 0.8940909505, green: 0.8940883279, blue: 0.898322165, alpha: 1)
              return add
          }()
    let nameText: UITextField = {
              let name = UITextField()
              name.translatesAutoresizingMaskIntoConstraints = false
              name.placeholder = " Название таймера"
              name.layer.cornerRadius = 5
              name.layer.masksToBounds = true
              name.layer.borderColor = #colorLiteral(red: 0.8940909505, green: 0.8940883279, blue: 0.898322165, alpha: 1)
              name.layer.borderWidth = 1.0
              return name
          }()
    let timeText: UITextField = {
              let time = UITextField()
              time.translatesAutoresizingMaskIntoConstraints = false
              time.placeholder = " Время в секундах"
              time.layer.cornerRadius = 5
              time.layer.masksToBounds = true
              time.layer.borderColor = #colorLiteral(red: 0.8940909505, green: 0.8940883279, blue: 0.898322165, alpha: 1)
              time.layer.borderWidth = 1.0
              return time
          }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timerList.isUserInteractionEnabled = true
        // MARK: Tableview delegating
        timerList.tableFooterView = UIView()
        timerList.separatorStyle = .singleLine
        timerList.separatorColor = .none
        addButton.addTarget(self, action: #selector(addNewTimer), for: .touchUpInside)
        timerList.dataSource = self
        timerList.delegate = self
        
        setupview()
    }

    
    func setupview() {
        
        // MARK: Elements constaints
        view.addSubview(addTimersLabel)
        addTimersLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 3).isActive = true
        addTimersLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        
        view.addSubview(lineView)
        lineView.topAnchor.constraint(equalTo: addTimersLabel.bottomAnchor, constant: 4).isActive = true
        lineView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(nameText)
        nameText.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 7).isActive = true
        nameText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 3).isActive = true
        nameText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        view.addSubview(timeText)
        timeText.topAnchor.constraint(equalTo: nameText.bottomAnchor, constant: 3).isActive = true
        timeText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 3).isActive = true
        timeText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        view.addSubview(addButton)
        addButton.topAnchor.constraint(equalTo: timeText.bottomAnchor, constant: 18).isActive = true
        addButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(timersLabel)
        timersLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 35).isActive = true
        timersLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4).isActive = true
        view.addSubview(timerList)
        
        timerList.topAnchor.constraint(equalTo: timersLabel.bottomAnchor).isActive = true
        timerList.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        timerList.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        timerList.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
   
    // MARK: Button func
    @objc func addNewTimer(_ sender: UIButton) {
    
          let task = Time(name:nameText.text ?? "",time: timeText.text ?? "")
          
          timerArray.append(task)
          let indexPath = IndexPath(row: timerArray.count - 1, section: 0)
            
          timerList.beginUpdates()
          timerList.insertRows(at: [indexPath], with: .top)
          timerList.endUpdates()
        guard let visibleRowsIndexPaths = timerList.indexPathsForVisibleRows else {
          return
        }
        for indexPath in visibleRowsIndexPaths {
          if let cell = timerList.cellForRow(at: indexPath) as? TimerCell {
            cell.createTimer()
          }
        }
      }
    func deleteTimer(indexPath: IndexPath) {
        timerList.beginUpdates()
        timerList.deleteRows(at: [indexPath], with: .fade)
//        timerArray.remove(at: indexPath.row )
        print(timerArray.count)
        timerList.endUpdates()
      }
    
 // MARK: Big title 
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Мульти таймер"
        view.backgroundColor = .white
    }
    
    
}

