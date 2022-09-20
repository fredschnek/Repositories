//
//  ProfileViewController.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import UIKit

class ProfileViewController: UIViewController, Stateful, MainCoordinated, UsersCoordinated {
    @IBOutlet private weak var tableView: UITableView!
    private var dataSource: ProfileTableViewDataSource?
    var stateController: StateController?
    
    weak var mainCoordinator: MainFlowCoordinator?
    weak var usersCoordinator: UsersFlowCoordinator?
    
    @IBAction func cancel(_ segue: UIStoryboardSegue) {}
}

// MARK: UIViewController

extension ProfileViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = stateController?.user else {
            return
        }
        let dataSource = ProfileTableViewDataSource(user: user)
        self.dataSource = dataSource
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        mainCoordinator?.configure(viewController: segue.destination)
    }
}

// MARK: UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSource?.section(at: section).headerHeight ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource.map { dataSource in
            let row = dataSource.row(at: indexPath)
            (row as? Section.DetailRow).map { row in
                let details = stateController?.user?.details.fetchedValue
                switch row {
                case .email: details?.email.map { usersCoordinator?.profileViewController(self, didSelectEmail: $0) }
                case .blog: details?.blog.map { mainCoordinator?.viewController(self, didSelectURL: $0) }
                default: break
                }
            }
            (row as? Section.ListRow).map { row in
                switch row {
                case .followers, .following: usersCoordinator?.profileViewControllerDidSelectUsers(self)
                case .repositories, .stars: usersCoordinator?.profileViewControllerDidSelectRepositories(self)
                }
            }
        }
    }
}

// MARK: - Section

extension ProfileViewController {
    enum Section {
        case summary([SummaryRow])
        case details([DetailRow])
        case lists([ListRow])
        
        var rows: [RowType] {
            switch self {
            case let .summary(rows): return rows
            case let .details(rows): return rows
            case let .lists(rows): return rows
            }
        }
        
        var headerHeight: CGFloat {
            switch self {
            case .summary: return 24.0
            case .details, .lists: return 32.0
            }
        }
        
        var separator: UITableViewCell.SeparatorType {
            switch self {
            case .lists: return .insetted(24.0)
            case .summary, .details: return .none
            }
        }
    }
}

protocol RowType {
    var cellType: UITableViewCell.Type { get }
}

extension ProfileViewController.Section {
    enum SummaryRow: RowType {
        case avatar
        case name
        case username
        case bio
        
        var style: SummaryCell.ViewModel.Style {
            switch self {
            case .name: return SummaryCell.ViewModel.Style(margin: 8.0, size: 24.0, weight: .medium, color: .cork, alignment: .center)
            case .username: return SummaryCell.ViewModel.Style(margin: 16.0, size: 14.0, weight: .light, color: .dustyGray, alignment: .center)
            case .bio: return SummaryCell.ViewModel.Style(margin: 0.0, size: 14.0,  weight: .regular, color: .cork, alignment: .left)
            case .avatar:
                assertionFailure("There is no style for the avata row")
                return SummaryCell.ViewModel.Style()
            }
        }
        
        var cellType: UITableViewCell.Type {
            switch self {
            case .avatar: return AvatarCell.self
            case .name, .username, .bio: return SummaryCell.self
            }
        }
    }
    
    enum DetailRow: RowType {
        case email
        case blog
        case company
        case location
        
        var icon: UIImage {
            switch self {
            case .email: return #imageLiteral(resourceName: "Email")
            case .blog: return #imageLiteral(resourceName: "Blog")
            case .company: return #imageLiteral(resourceName: "Company")
            case .location: return #imageLiteral(resourceName: "Location")
            }
        }
        
        var isActive: Bool {
            switch self {
            case .email, .blog: return true
            case .company, .location: return false
            }
        }
        
        var cellType: UITableViewCell.Type {
            return DetailCell.self
        }
    }
    
    enum ListRow: RowType {
        case repositories
        case stars
        case followers
        case following
        
        var name: String {
            switch self {
            case .repositories: return "Repositories"
            case .stars: return "Stars"
            case .followers: return "Followers"
            case .following: return "Following"
            }
        }
        
        var cellType: UITableViewCell.Type {
            return ListCell.self
        }
    }
}
