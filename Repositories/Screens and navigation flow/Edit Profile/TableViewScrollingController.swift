//
//  TableViewScrollingController.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import UIKit

class TableViewScrollingController: NSObject {
    @IBOutlet private weak var tableView: UITableView!
    
    var keyboardFrame: CGRect? {
        didSet {
            adjustTableView()
            scrollToActiveViewFrame()
        }
    }
    
    var activeViewFrame: CGRect? {
        didSet {
            scrollToActiveViewFrame()
        }
    }
}

// MARK: Private
private extension TableViewScrollingController {
    func adjustTableView() {
        let bottomInset = keyboardFrame?.height ?? 0.0
        let inset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: bottomInset, right: 0.0)
        tableView.contentInset = inset
        tableView.scrollIndicatorInsets = inset
    }
    
    func scrollToActiveViewFrame() {
        guard let activeViewFrame = activeViewFrame,
              let keyboardFrame = keyboardFrame else {
            return
        }
        var visibleRect = tableView.frame
        visibleRect.size.height -= keyboardFrame.height
        if !visibleRect.contains(activeViewFrame.origin) {
            UIView.animate(withDuration: 0.2, animations: {
                // The animation block is needed because setting the animated parameter to true works intermittenlty
                self.tableView.scrollRectToVisible(activeViewFrame, animated: false)
            })
        }
    }
}

// MARK: - ScrollingDelegate
protocol ScrollingDelegate: AnyObject {
    func activeViewDidChange(_ view: UIView?)
}
