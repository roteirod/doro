//
//  SavedConfigurationCell.swift
//  doro
//
//  Created by Volodymyr Davydenko on 10.05.2021.
//

import UIKit

class SavedConfigurationCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblFocus: UILabel!
    @IBOutlet weak var lblShortBreak: UILabel!
    @IBOutlet weak var lblLongBreak: UILabel!
    
    @IBOutlet weak var lblPomodoros: UILabel!
    
    @IBOutlet weak var constraintViewFocusWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintViewShortBreakWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintViewLongBreakWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
