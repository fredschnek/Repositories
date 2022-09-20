//
//  DetailInputCell.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import UIKit

// MARK: - InputCellDelegate
protocol DetailInputCellDelegate: ScrollingDelegate {
    func inputCell(_ cell: DetailInputCell, didChange text: String)
    func inputCellDidReturn(_ cell: DetailInputCell)
}

class DetailInputCell: UITableViewCell {
    @IBOutlet private weak var fieldLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var errorMessageLabel: UILabel!
    
    weak var delegate: DetailInputCellDelegate?
    
    var viewModel = ViewModel() {
        didSet {
            fieldLabel.text = viewModel.label
            textField.text = viewModel.text
            textField.placeholder = viewModel.placeholder
            errorMessageLabel.text = viewModel.errorMessage
            errorMessageLabel.isHidden = viewModel.isValid
        }
    }
    
    @IBAction func textChanged(_ sender: Any) {
        delegate?.inputCell(self, didChange: textField.text ?? "")
    }
}

// MARK: UITextFieldDelegate
extension DetailInputCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.activeViewDidChange(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.activeViewDidChange(nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.inputCellDidReturn(self)
        return false
    }
}

// MARK: CursorShowing
extension DetailInputCell: CursorShowing {
    func showCursor() {
        textField.becomeFirstResponder()
    }
}

// MARK: - ViewModel
extension DetailInputCell {
    struct ViewModel {
        var label = ""
        var text = ""
        var placeholder = ""
        var errorMessage = ""
        var isValid = true
    }
}
