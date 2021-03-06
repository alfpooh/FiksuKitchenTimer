//
//  ViewController.swift
//  Fiksu Kitchen Timer
//
//  Created by donghoon bae on 2016. 7. 1..
//  Copyright © 2016년 Forethink. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    
    let synth = AVSpeechSynthesizer()
    var sayCount = AVSpeechUtterance(string: "")
    let targetTime = [5,12,15,10,4,14]
    var isPaused = false
    var isTimerOn = false
    var pausedTime: NSTimeInterval!
    var timer = NSTimer()
    var transferText: String! = "0"
    
    @IBOutlet weak var targetTimeLabel: UILabel!

    
    @IBOutlet weak var elapsedTimeLabel: UILabel!

    let watch = Watch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //target time should be decided from selecting menu later!
        let timerindex = Int(transferText)!
        if targetTime[timerindex] < 10 {
        targetTimeLabel.text = "0\(targetTime[timerindex]):00"
        } else {
        targetTimeLabel.text = "\(targetTime[timerindex]):00"}

    }
    
    @IBAction func PlusMinute(sender: AnyObject) {
        let timerindex = Int(transferText)!
        let timenowplusonemin = Double(watch.elapsedTime) + 60.0
        let targettimenow = Double(targetTime[timerindex] * 60)
        if timer.valid {
            if timenowplusonemin <= targettimenow {
                watch.addOneMinute()
                VoiceOut(5)} else {VoiceOut(7)}
        }
    }
    
    @IBAction func backtomenu(sender: AnyObject) {
        if timer.valid { watch.pause()
        timer.invalidate()
            dismissViewControllerAnimated(true, completion: nil)}
        
    }
    
    @IBAction func MinusMinute(sender: AnyObject) {
        let timenow = watch.elapsedTime
        if timer.valid {
            if  timenow > 60 {
                watch.minusOneMinute()
                VoiceOut(6)} else {VoiceOut(7)} }
    }
    
    
//    @IBAction func pauseButtonTapped(sender: AnyObject) {
//        
//        if isPaused == true {
//            // for resume
//            isTimerOn = !isTimerOn
//             resumeTimer(pausedTime)
//        }
//            
//        else {
//            // for pause
//            
//            watch.pause()
//            VoiceOut(3)
//            timer.invalidate()
//        }
//        self.pausedTime = 0.0
//        isPaused = !isPaused
//        isTimerOn = !isTimerOn
//    }
    
    @IBAction func startButtonTapped(sender: UIButton) {
        if isTimerOn == false {
            VoiceOut(0)
            watch.start()
                if !timer.valid {timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self,
                                                                           selector: #selector(ViewController.updateElapsedTimeLabel(_:)), userInfo: nil, repeats: true)

        
                } else {
                        print ("play button is pressed while timer counting")
                        }
            
        } else {
            watch.pause()
            VoiceOut(3)
            timer.invalidate()
            self.pausedTime = 0.0
        }
        isTimerOn = !isTimerOn

    }
    
    @IBAction func stopButtonTapped(sender: UIButton) {
        watch.stop()
    }
    
    func resumeTimer(lastTime: NSTimeInterval) {
 

         VoiceOut(4)
        if !timer.valid {NSTimer.scheduledTimerWithTimeInterval(0.1, target: self,
                                                                selector: #selector(ViewController.updateElapsedTimeLabel(_:)), userInfo: nil, repeats: true)
                        }

        
        watch.start()
    }
    
    func VoiceOut(index: Int){
        if index == 0 {
        sayCount = AVSpeechUtterance(string: "Timer Starts")
        sayCount.rate = 0.5
            synth.speakUtterance(sayCount)}
        else if index == 1 {
            sayCount = AVSpeechUtterance(string: "Time out!")
            sayCount.rate = 0.5
            synth.speakUtterance(sayCount)}
         else if index == 2 {
            sayCount = AVSpeechUtterance(string: "One minute left")
            sayCount.rate = 0.5
            synth.speakUtterance(sayCount)}
        else if index == 3 {
            sayCount = AVSpeechUtterance(string: "Timer paused")
            sayCount.rate = 0.5
            synth.speakUtterance(sayCount)}
        else if index == 4 {
            sayCount = AVSpeechUtterance(string: "Timer continues")
            sayCount.rate = 0.5
            synth.speakUtterance(sayCount)}
        else if index == 5 {
            sayCount = AVSpeechUtterance(string: "Jump one minute")
            sayCount.rate = 0.5
            synth.speakUtterance(sayCount)}
        else if index == 6 {
            sayCount = AVSpeechUtterance(string: "One minute more")
            sayCount.rate = 0.5
            synth.speakUtterance(sayCount)}
        else if index == 7 {
            sayCount = AVSpeechUtterance(string: "Beep")
            sayCount.rate = 0.5
            synth.speakUtterance(sayCount)}
    }



    func updateElapsedTimeLabel(timer: NSTimer) {
        

        if isTimerOn == false {
            watch.start()
            isTimerOn = !isTimerOn
            return
        } else {
        

        // normally timer is running now
        if watch.isRunning {
            
            // if it is target time stop and alert
            if targetTimeLabel.text == elapsedTimeLabel.text {
                //stop watch
                timer.invalidate()
                watch.stop()
                VoiceOut(1)
                
                //initialize
                self.pausedTime = 0.0
                elapsedTimeLabel.text = "00:00"

                isTimerOn = !isTimerOn

                
            }
            // normally update label with new elapsed time
            elapsedTimeLabel.text = watch.elapsedTimeAsString
        } else {
            // if watch is not running, off timer.
            timer.invalidate()
        }
            
        }
    }

    
}

