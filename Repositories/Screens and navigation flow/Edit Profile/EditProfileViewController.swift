//
//  EditProfileViewController.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import UIKit

class EditProfileViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    @IBOutlet private var scrollingController: TableViewScrollingController!
    
    private var dataSource: EditProfileTableViewDataSource?
    private var keyboardObservers: [NSObjectProtocol] = []
}

// MARK: UIViewController
extension EditProfileViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        guard let user: User = Loader.loadDataFromJSONFile(withName: "User") else {
            return
        }
        let dataSource = EditProfileTableViewDataSource(user: user)
        self.dataSource = dataSource
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.reloadData()
    }
}

// MARK: UITableViewDelegate
extension EditProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch cell {
        case let cell as AvatarInputCell: cell.delegate = self
        case let cell as DetailInputCell: cell.delegate = self
        case let cell as BioInputCell: cell.delegate = self
        default: break
        }
    }
}

// MARK: ScrollingDelegate
extension EditProfileViewController: ScrollingDelegate {
    func activeViewDidChange(_ view: UIView?) {
        guard let activeView = view else {
            scrollingController.activeViewFrame = nil
            return
        }
        let frame = activeView.convert(activeView.bounds, to: tableView)
        scrollingController.activeViewFrame = frame
    }
}

// MARK: AvatarInputCellDelegate
extension EditProfileViewController: AvatarInputCellDelegate {
    func photoCellDidEditPhoto(_ cell: AvatarInputCell) {
        show(UIImagePickerController(), sender: nil)
    }
}

// MARK: DetailInputCellDelegate
extension EditProfileViewController: DetailInputCellDelegate {
    func inputCell(_ cell: DetailInputCell, didChange text: String) {
        guard let dataSource = dataSource,
              let index = tableView.indexPath(for: cell)?.row else {
            return
        }
        dataSource.set(text: text, at: index)
        saveButton.isEnabled = dataSource.isDataValid
        tableView.performBatchUpdates({
            cell.configure(with: dataSource.row(at: index))
        }, completion: nil)
    }
    
    func inputCellDidReturn(_ cell: DetailInputCell) {
        tableView.showCursorInCell(after: cell)
    }
}

// MARK: BioInputCellDelegate
extension EditProfileViewController: BioInputCellDelegate {
    func bioCell(_ cell: BioInputCell, didChange text: String) {
        UIView.setAnimationsEnabled(false)
        tableView.performBatchUpdates({
            guard let index = tableView.indexPath(for: cell)?.row else {
                return
            }
            dataSource?.set(text: text, at: index)
        }, completion: { _ in
            UIView.setAnimationsEnabled(true)
        })
    }
}

// MARK: Private
private extension EditProfileViewController {
    func registerForKeyboardNotifications() {
        let defaultCenter = NotificationCenter.default
        let keyboardDidShowObserver = defaultCenter.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: nil, using: { [weak self] notification in
            self?.scrollingController.keyboardFrame = notification.keyboardFrame
        })
        let keyboardDidHideObserver = defaultCenter.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: nil, using: { [weak self] notification in
            self?.scrollingController.keyboardFrame = nil
        })
        keyboardObservers = [keyboardDidShowObserver, keyboardDidHideObserver]
    }
}

// MARK: - Row
extension EditProfileViewController {
    enum Row {
        case avatar(UIImage)
        case name(String)
        case blog(String)
        case company(String)
        case location(String)
        case bio(String)
        
        var cellType: UITableViewCell.Type {
            switch self {
            case .avatar: return AvatarInputCell.self
            case .name, .blog, .company, .location: return DetailInputCell.self
            case .bio: return BioInputCell.self
            }
        }
        
        var separator: UITableViewCell.SeparatorType {
            switch self {
            case .avatar: return .none
            case .name, .blog, .company, .location, .bio: return .insetted(24.0)
            }
        }
        
        var label: String {
            switch self {
            case .name: return "Name"
            case .blog: return "Blog"
            case .company: return "Company"
            case .location: return "Location"
            case .bio: return "Bio"
            case .avatar:
                assertionFailure("The avatar has no label")
                return ""
            }
        }
        
        var placeHolder: String {
            switch self {
            case .name: return "Name or nickname"
            case .blog: return "example.com"
            case .company: return "Company name"
            case .location: return "City"
            case .bio: return "Tell us a bit about yourself"
            case .avatar:
                assertionFailure("The avatar has no placeholder")
                return ""
            }
        }
        
        var errorMessage: String {
            switch self {
            case .name, .company, .location: return ""
            case .blog: return "The URL is not valid"
            case .bio:
                assertionFailure("The bio has no error message")
                return ""
            case .avatar:
                assertionFailure("The avatar has no error message")
                return ""
            }
        }
    }
}

// MARK: - Notification
extension Notification {
    var keyboardFrame: CGRect {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
    }
}
