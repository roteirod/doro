//
//  ViewController.swift
//  doro
//
//  Created by Volodymyr Davydenko on 04.05.2021.
//

import UIKit
import MKRingProgressView

class TimerViewController: UIViewController {

    static func storyboardInstance() -> TimerViewController? {
        let storyboard = UIStoryboard(name: "TimerViewController", bundle: nil)
        return storyboard.instantiateInitialViewController() as? TimerViewController
    }
    
    @IBOutlet weak var viewProgressContainer: UIView!
    @IBOutlet weak var lblFocusRest: UILabel!
    
    @IBOutlet weak var lblPomodoros: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var btnStartStop: UIButton!
    
    var totalProgressView = RingProgressView()
    var focusProgressView = RingProgressView()
    var restProgressView = RingProgressView()
    
    var currentState: SessionState = .notStarted {
        didSet {
            configureProgressCirclesState()
            updateButtonState()
        }
    }
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addProgressCircles()
        configureStartStopButton()
        
        if DataManager.shared.currentSession?.count ?? 0 > 0 {
            runTimer()
        }
    }

    //MARK: - Handling Button Taps
    
    @IBAction func startStopTapped(_ sender: Any) {
        if currentState == .inFocus || currentState == .inBreak {
            currentState = .notStarted
            timer.invalidate()

            DataManager.shared.cleanSession()
        } else {
            goToParameters()
        }
    }
    
    //MARK: - Handling Transition to Other Screens
    
    func goToParameters() {
        if let parametersViewController = ParametersViewController.storyboardInstance() {
            parametersViewController.modalPresentationStyle = .pageSheet
            parametersViewController.modalTransitionStyle = .coverVertical
            parametersViewController.delegate = self
            
            let navigationController = UINavigationController(rootViewController: parametersViewController)
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    //MARK: - Handling UI Elements Appearance
    
    func addProgressCircles() {
        totalProgressView = RingProgressView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 60, height: self.view.frame.width - 60))
        totalProgressView.startColor = .pomoGreenLight
        totalProgressView.endColor = .pomoGreen
        totalProgressView.ringWidth = 10
        totalProgressView.shadowOpacity = 0.3
        totalProgressView.progress = 0
        viewProgressContainer.addSubview(totalProgressView)
        
        focusProgressView = RingProgressView(frame: CGRect(x: 12, y: 12, width: self.view.frame.width - 84, height: self.view.frame.width - 84))
        focusProgressView.startColor = .pomoRedLight
        focusProgressView.endColor = .pomoRed
        focusProgressView.ringWidth = 20
        focusProgressView.shadowOpacity = 0.3
        focusProgressView.progress = 0
        focusProgressView.alpha = 1
        viewProgressContainer.addSubview(focusProgressView)
        
        restProgressView = RingProgressView(frame: CGRect(x: 12, y: 12, width: self.view.frame.width - 84, height: self.view.frame.width - 84))
        restProgressView.startColor = .pomoYellowLight
        restProgressView.endColor = .pomoYellow
        restProgressView.ringWidth = 20
        restProgressView.shadowOpacity = 0.3
        restProgressView.progress = 1
        restProgressView.alpha = 0
        viewProgressContainer.addSubview(restProgressView)
    }
    
    func configureProgressCirclesState() {
        UIView.animate(withDuration: 0.5) {
            switch self.currentState {
            case .inBreak:
                self.focusProgressView.alpha = 0
                self.restProgressView.alpha = 1
            case .completed:
                self.focusProgressView.alpha = 0
                self.restProgressView.alpha = 0
            default :
                self.focusProgressView.alpha = 1
                self.restProgressView.alpha = 0
            }
        }
    }
    
    func setProgress(index: Int, timeLeft: Double, currentProgress: Double, totalSpent: Double, totalProgress: Double) {
        totalProgressView.progress = totalProgress
        
        let currentMinutes = String(format: "%02d", Int(timeLeft.rounded()).quotientAndRemainder(dividingBy: 60).quotient)
        let currentSeconds = String(format: "%02d", Int(timeLeft.rounded()).quotientAndRemainder(dividingBy: 60).remainder)
        
        let timeLeftString = NSMutableAttributedString(string: currentState == .inFocus ? "Focus for" : "Rest for", attributes: [.font : UIFont.quattrocentoSansRegular(ofSize: 25)])
        timeLeftString.append(NSAttributedString(string: "\n\(currentMinutes):\(currentSeconds)", attributes: [.font : UIFont.quattrocentoSansRegular(ofSize: 64)]))
        
        lblFocusRest.attributedText = currentState == .completed ? NSAttributedString(string: "Done!", attributes: [.font : UIFont.quattrocentoSansRegular(ofSize: 64)]) : timeLeftString
        
        let pomodorosString = NSMutableAttributedString(string: "pomodoro", attributes: [.font : UIFont.quattrocentoSansRegular(ofSize: 17)])
        pomodorosString.append(NSAttributedString(string: "\n\(index + 1)/\(DataManager.shared.currentSession?.count ?? 0)", attributes: [.font : UIFont.quattrocentoSansRegular(ofSize: 25)]))
        lblPomodoros.attributedText = pomodorosString
        
        let totalMinutes = String(format: "%02d", Int(totalSpent.rounded()).quotientAndRemainder(dividingBy: 60).quotient)
        let totalSeconds = String(format: "%02d", Int(totalSpent.rounded()).quotientAndRemainder(dividingBy: 60).remainder)
        
        let totalSpentString = NSMutableAttributedString(string: "total", attributes: [.font : UIFont.quattrocentoSansRegular(ofSize: 17)])
        totalSpentString.append(NSAttributedString(string: "\n\(totalMinutes):\(totalSeconds)", attributes: [.font : UIFont.quattrocentoSansRegular(ofSize: 20)]))
        lblTotal.attributedText = totalSpentString
        
        switch currentState {
        case .inFocus:
            focusProgressView.progress = currentProgress
        case .inBreak:
            restProgressView.progress = currentProgress
        default:
            focusProgressView.progress = 0
            restProgressView.progress = 0
        }
    }
    
    func updateButtonState() {
        if currentState == .inFocus || currentState == .inBreak {
            btnStartStop.setTitle("Stop", for: .normal)
            btnStartStop.backgroundColor = .pomoRed
        } else {
            btnStartStop.backgroundColor = .pomoGreen
            btnStartStop.setTitle("Start", for: .normal)
        }
    }
    
    func configureStartStopButton() {
        btnStartStop.layer.cornerRadius = btnStartStop.frame.height / 2
        btnStartStop.clipsToBounds = true
    }
}

extension TimerViewController: SessionParametersDelegate {
    func startSession(pomodoros: Int, focus: Double, shortBreak: Double, longBreak: Double) {
        DataManager.shared.configureSession(pomodoros: pomodoros, focus: focus, shortBreak: shortBreak, longBreak: longBreak)
        runTimer()
    }
    
    func runTimer() {
        currentState = .notStarted
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if self.currentState == .completed {
                self.timer.invalidate()
            } else {
                DataManager.shared.currentSessionState { (index, state, timeLeft, currentProgress, totalSpent, totalProgress) in
                    if state != self.currentState {
                        self.currentState = state
                    }
                    
                    self.setProgress(index: index, timeLeft: timeLeft, currentProgress: currentProgress, totalSpent: totalSpent, totalProgress: totalProgress)
                }
            }
        }
    }
}

