//
//  CustomTextField.swift
//  doro
//
//  Created by Volodymyr Davydenko on 10.05.2021.
//

import UIKit

class CustomTextField: UITextField {

    let textPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var rightViewImage = UIImage(named: "btnClear")
    
    var rightViewType: RightViewType = .cancel {
        didSet {
            switch rightViewType {
            case .cancel:
                rightViewImage = UIImage(named: "btnClear")
                initialize()
            case .arrowDown:
                rightViewImage = UIImage(named: "btnArrowDown")
                initialize()
            }
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    func initialize() {
        let clearButton = UIButton(frame: CGRect(x: 0, y: 0, width: 9, height: 9))
        clearButton.setImage(rightViewImage, for: [])

        self.rightView = clearButton
        clearButton.addTarget(self, action: #selector(clearClicked), for: .touchUpInside)

        self.clearButtonMode = .never
        self.rightViewMode = .always
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let frame = CGRect(x: bounds.width - 25, y: (bounds.height - 9) / 2, width: 9, height: 9)
        return frame
    }

    @objc func clearClicked(sender:UIButton) {
        if rightViewType == .cancel {
            text = ""
            delegate?.textFieldShouldClear?(self)
        } else if rightViewType == .arrowDown {
            becomeFirstResponder()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

enum RightViewType {
    case cancel
    case arrowDown
}
