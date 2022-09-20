//
//  BioInputCell.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import UIKit

protocol BioInputCellDelegate: ScrollingDelegate {
    func bioCell(_ cell: BioInputCell, didChange text: String)
}

class BioInputCell: UITableViewCell {
    weak var delegate: BioInputCellDelegate?
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.textContainerInset = UIEdgeInsets.zero
            textView.textContainer.lineFragmentPadding = 0
            textView.delegate = self
        }
    }
    
    var bioText = "" {
        didSet {
            textView.text = bioText
        }
    }
}

// MARK: UITextViewDelegate
extension BioInputCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.bioCell(self, didChange: textView.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.activeViewDidChange(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.activeViewDidChange(nil)
    }
}

// MARK: CursorShowing
extension BioInputCell: CursorShowing {
    func showCursor() {
        textView.becomeFirstResponder()
    }
}
