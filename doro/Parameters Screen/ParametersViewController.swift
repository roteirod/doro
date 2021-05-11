//
//  ParametersViewController.swift
//  doro
//
//  Created by Volodymyr Davydenko on 04.05.2021.
//

import UIKit
import PMAlertController

protocol SessionParametersDelegate {
    func startSession(pomodoros: Int, focus: Double, shortBreak: Double, longBreak: Double)
}

class ParametersViewController: UIViewController {

    static func storyboardInstance() -> ParametersViewController? {
        let storyboard = UIStoryboard(name: "ParametersViewController", bundle: nil)
        return storyboard.instantiateInitialViewController() as? ParametersViewController
    }
    
    @IBOutlet var lblValues: [UILabel]!
    @IBOutlet var sliders: [CustomSlider]!
    
    @IBOutlet weak var btnConfirm: UIButton!
    
    let defaultValues: [Int] = [25, 5, 15, 4]
    
    var delegate: SessionParametersDelegate?
    
    var saveConfigPopup = PMAlertController()
    var messagePopup = PMAlertController(title: "", description: "", image: nil, style: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    //MARK: - Handling Button Taps
    
    @IBAction func resetTapped(_ sender: Any) {
        setDefaultValues(animated: true)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        present(saveConfigPopup, animated: true, completion: nil)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        lblValues[sender.tag].text = sender.tag == 3 ? "\(Int(sliders[sender.tag].value.rounded()))" : "\(Int(sliders[sender.tag].value.rounded())):00"
    }
    
    @IBAction func confirmTapped(_ sender: Any) {
        delegate?.startSession(pomodoros: Int(sliders[3].value.rounded()), focus: Double(sliders[0].value.rounded() * 60), shortBreak: Double(sliders[1].value.rounded() * 60), longBreak: Double(sliders[2].value.rounded() * 60))
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chooseSavedTapped(_ sender: Any) {
        goToSavedConfigurations()
    }
    
    @IBAction func runTestTapped(_ sender: Any) {
        delegate?.startSession(pomodoros: 4, focus: 10, shortBreak: 2, longBreak: 3)
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Handling Transition to Other Screens
    
    func goToSavedConfigurations() {
        if let savedConfigurationsViewController = SavedConfigurationsViewController.storyboardInstance() {
            savedConfigurationsViewController.delegate = self.delegate
            navigationController?.pushViewController(savedConfigurationsViewController, animated: true)
        }
    }
    
    //MARK: - Handling UI Elements Appearance
    
    func setDefaultValues(animated: Bool) {
        lblValues.forEach { (lblValue) in
            lblValue.text = lblValue.tag == 3 ? "\(defaultValues[lblValue.tag])" : "\(defaultValues[lblValue.tag]):00"
            
            sliders[lblValue.tag].setValue(Float(defaultValues[lblValue.tag]), animated: animated)
        }
    }
    
    func configureSubviews() {
        setDefaultValues(animated: false)
        lblValues.forEach { (label) in
            label.layer.cornerRadius = 4
            label.clipsToBounds = true
        }
        
        btnConfirm.layer.cornerRadius = btnConfirm.frame.height / 2
        btnConfirm.clipsToBounds = true
        
        configureSavePopup()
        configureMessagePopup()
    }
    
    func presentMessagePopup(title: String, body: String) {
        messagePopup.alertTitle.text = title
        messagePopup.alertDescription.text = body
        
        present(messagePopup, animated: true, completion: nil)
    }
    
    func configureSavePopup() {
        saveConfigPopup = PMAlertController(title: "Configuration", description: "Do you want to save this configuration?", image: nil, style: .alert)
        saveConfigPopup.gravityDismissAnimation = false
        saveConfigPopup.dismissWithBackgroudTouch = true
        
        saveConfigPopup.alertTitle.font = UIFont.quattrocentoSansBold(ofSize: 16)
        saveConfigPopup.alertTitle.textColor = .pomoGreen
        saveConfigPopup.alertDescription.font = UIFont.quattrocentoSansRegular(ofSize: 16)
        saveConfigPopup.alertDescription.textColor = UIColor.blueGrey
        
        saveConfigPopup.alertView.layer.cornerRadius = 15
        saveConfigPopup.alertView.clipsToBounds = true
        
        saveConfigPopup.alertContentStackViewLeadingConstraint.constant = 20
        saveConfigPopup.alertContentStackViewTrailingConstraint.constant = 20
        saveConfigPopup.alertActionStackViewTopConstraint.constant = 0
        saveConfigPopup.alertActionStackViewBottomConstraint.constant = 10
        saveConfigPopup.alertActionStackViewLeadingConstraint.constant = 20
        saveConfigPopup.alertActionStackViewTrailingConstraint.constant = 20
        
        saveConfigPopup.ALERT_STACK_VIEW_HEIGHT = 40
        
        let configTextField = CustomTextField()
        
        let saveButton = PMAlertAction(title: "Save", style: .default) {
            if configTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                self.presentMessagePopup(title: "Error", body: "Please enter a configuration name")
            } else {
                DataManager.shared.saveConfiguration(title: configTextField.text!, pomodoros: Int(self.sliders[3].value.rounded()), focus: Double(self.sliders[0].value.rounded() * 60), shortBreak: Double(self.sliders[1].value.rounded() * 60), longBreak: Double(self.sliders[2].value.rounded() * 60))
                
                self.presentMessagePopup(title: "Success", body: "The configuration has been saved!")
            }
        }
        saveButton.titleLabel?.font = UIFont.quattrocentoSansBold(ofSize: 18)
        saveButton.setTitleColor(UIColor.pomoGreen, for: .normal)
        saveButton.separator.removeFromSuperview()

        saveConfigPopup.addTextField(textField: configTextField) { (textField) in
            textField?.autocapitalizationType = .sentences
            textField?.tintColor = UIColor.blueGrey
            textField?.font = UIFont.quattrocentoSansItalic(ofSize: 15)
            textField?.textColor = UIColor.blueGrey
            textField?.textAlignment = .center
            textField?.placeholder = "Configuration name"
        }

        saveConfigPopup.modalPresentationStyle = .overFullScreen
        saveConfigPopup.addAction(saveButton)
    }
    
    func configureMessagePopup() {
        messagePopup.gravityDismissAnimation = false
        messagePopup.dismissWithBackgroudTouch = true
        
        messagePopup.alertTitle.font = UIFont.quattrocentoSansBold(ofSize: 16)
        messagePopup.alertTitle.textColor = .pomoGreen
        messagePopup.alertDescription.font = UIFont.quattrocentoSansRegular(ofSize: 16)
        messagePopup.alertDescription.textColor = UIColor.blueGrey
        
        messagePopup.alertView.layer.cornerRadius = 15
        messagePopup.alertView.clipsToBounds = true
        
        messagePopup.alertContentStackViewLeadingConstraint.constant = 20
        messagePopup.alertContentStackViewTrailingConstraint.constant = 20
        messagePopup.alertActionStackViewTopConstraint.constant = 10
        messagePopup.alertActionStackViewBottomConstraint.constant = 10
        
        messagePopup.ALERT_STACK_VIEW_HEIGHT = 40

        let okButton = PMAlertAction(title: "Ok", style: .default) {
        }
        okButton.titleLabel?.font = UIFont.quattrocentoSansBold(ofSize: 18)
        okButton.setTitleColor(UIColor.pomoGreen, for: .normal)
        okButton.separator.removeFromSuperview()

        messagePopup.modalPresentationStyle = .overFullScreen
        messagePopup.addAction(okButton)
    }
}
