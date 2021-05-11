//
//  SavedConfigurationsScreen.swift
//  doro
//
//  Created by Volodymyr Davydenko on 05.05.2021.
//

import UIKit

class SavedConfigurationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    static func storyboardInstance() -> SavedConfigurationsViewController? {
        let storyboard = UIStoryboard(name: "SavedConfigurationsViewController", bundle: nil)
        return storyboard.instantiateInitialViewController() as? SavedConfigurationsViewController
    }
    
    @IBOutlet weak var savedConfigurationsTableView: UITableView!
    
    var delegate: SessionParametersDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        savedConfigurationsTableView.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
    }
    
    //MARK: - Handling Button Taps
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Handling Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if DataManager.shared.savedConfigurations?.count ?? 0 == 0 {
            let lblNoConfigurations = UILabel()
            lblNoConfigurations.textAlignment = .center
            lblNoConfigurations.numberOfLines = 0
            
            lblNoConfigurations.font = UIFont.quattrocentoSansRegular(ofSize: 18)
            lblNoConfigurations.textColor = UIColor.blueGrey
            
            lblNoConfigurations.text = "You don't have any saved\nconfigurations yet"
            savedConfigurationsTableView.backgroundView = lblNoConfigurations
        } else {
            savedConfigurationsTableView.backgroundView = nil
        }
        
        return DataManager.shared.savedConfigurations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SavedConfigurationCell
        
        let viewCellBackground = UIView()
        viewCellBackground.backgroundColor = UIColor.pomoGreen.withAlphaComponent(0.2)
        cell.selectedBackgroundView = viewCellBackground
        
        guard let configuration = DataManager.shared.savedConfigurations?[indexPath.row] else { return cell }
        
        cell.lblTitle.text = configuration.title
        cell.lblFocus.text = "\(Int(configuration.focusDuration / 60))min"
        cell.lblShortBreak.text = "\(Int(configuration.shortBreakDuration / 60))min"
        cell.lblLongBreak.text = "\(Int(configuration.longBreakDuration / 60))min"
        
        cell.lblPomodoros.text = "\(configuration.pomodoros)"
        
        let i = (Double(view.frame.width) - 40) / (configuration.focusDuration + configuration.shortBreakDuration + configuration.longBreakDuration)
        
        cell.constraintViewFocusWidth.constant = CGFloat(i * configuration.focusDuration)
        cell.constraintViewShortBreakWidth.constant = CGFloat(i * configuration.shortBreakDuration)
        cell.constraintViewLongBreakWidth.constant = CGFloat(i * configuration.longBreakDuration)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        savedConfigurationsTableView.deselectRow(at: indexPath, animated: true)
        
        guard let configuration = DataManager.shared.savedConfigurations?[indexPath.row] else { return }
        
        delegate?.startSession(pomodoros: configuration.pomodoros, focus: configuration.focusDuration, shortBreak: configuration.shortBreakDuration, longBreak: configuration.longBreakDuration)
        dismiss(animated: true, completion: nil)
    }
}
