//
//  TimerCell.swift
//  MultiTimer
//
//  Created by Дмитрий Жучков on 01.07.2021.
//

import UIKit
final class TimerCell: UITableViewCell {
    var resumeTapped = false
    var isTimerRunning = false
    var index: IndexPath?
    weak var timer: Timer?
    // MARK: Elements init
    var nameLabel: UILabel = {
                  let name = UILabel()
                   name.translatesAutoresizingMaskIntoConstraints = false
                   name.textColor = .black
                   return name
               }()
    var timeLabel: UILabel = {
                  let time = UILabel()
                   time.translatesAutoresizingMaskIntoConstraints = false
                   time.textColor = .lightGray
                   return time
               }()
    let pauseButton: UIButton = {
              let add = UIButton()
              add.translatesAutoresizingMaskIntoConstraints = false
              add.setTitleColor(.link, for: .normal)
              add.setTitle("Pause", for: .normal)
              add.layer.cornerRadius = 5
              add.layer.masksToBounds = true
              add.backgroundColor = #colorLiteral(red: 0.8940909505, green: 0.8940883279, blue: 0.898322165, alpha: 1)
              return add
          }()
    
    func configure() {
    
        // MARK: Elements constaints
        self.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.addSubview(timeLabel)
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.addSubview(pauseButton)
        pauseButton.rightAnchor.constraint(equalTo: timeLabel.leftAnchor,constant: -15).isActive = true
        pauseButton.topAnchor.constraint(equalTo: self.topAnchor,constant: 4).isActive = true
        pauseButton.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -4).isActive = true
        
        
        pauseButton.addTarget(self, action: #selector(pauseTimer), for: .touchUpInside)
        
        
    }
    
    // MARK: Data init
    var time: Time? {
      didSet {
        nameLabel.text = time?.name
        timeLabel.text = time?.time
        updateTime()
      }
    }

    
    // MARK: Timer update
    @objc func updateTime() {
      guard let time = time else {
        return
      }
        if Int(time.time) ?? 0 <= 0 {
            timer?.invalidate()
            self.isUserInteractionEnabled = false
//            let view = ViewController()
//            view.deleteTimer(indexPath: index!)
            
        }
        let hours = Int(time.time)! / 3600
        let minutes = Int(time.time)! / 60 % 60
        let seconds = Int(time.time)! % 60

        var times: [String] = []
        if hours > 0 {
          times.append("\(hours):")
        }
        if minutes > 0 {
          times.append("\(minutes):")
        }
        times.append("\(seconds)")

        timeLabel.text = times.joined(separator: "")
        time.time = "\(Int(time.time)! - 1)"
        
        
      }
    @objc func pauseTimer() {
        if self.resumeTapped == false {
            timer?.invalidate()
            isTimerRunning = false
            resumeTapped = true
            self.pauseButton.setTitle("Resume",for: .normal)
        } else {
            createTimer()
            resumeTapped = false
            isTimerRunning = true
            self.pauseButton.setTitle("Pause",for: .normal)
        }
    }
    func createTimer() {
      if timer == nil {
          let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
          timer.tolerance = 0.1
          RunLoop.current.add(timer, forMode: .common)
        self.timer = timer
      }
    }
    }

