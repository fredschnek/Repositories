//
//  MainTabBarControllerTransducer.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 20/10/22.
//

import Foundation

protocol MainTabBarControllerTransducerDelegate: AnyObject {
    func fetchRoot()
    func authenticate()
    func showAlert()
    func finishLaunch()
}

class MainTabBarControllerTransducer {
    weak var delegate: MainTabBarControllerTransducerDelegate?
    
    var state: State = .empty {
        didSet {
            switch state {
            case .waiting: delegate?.authenticate()
            case .loading: delegate?.fetchRoot()
            default: break
            }
        }
    }
    
    func fire(_ trigger: Trigger) {
        switch(state, trigger) {
        case (.empty, .load(authenticated: false)): state = .waiting
        case (.empty, .load(authenticated: true)): state = .loading
        case (.waiting, .load): state = .loading
        case (.loading, .errorOccurred(authenticated: false)): state = .waiting
        case (.loading, .errorOccurred(authenticated: true)):
            state = .empty
            delegate?.showAlert()
        case (.loading, .rootFetched):
            state = .loaded
            delegate?.finishLaunch()
        default: break
        }
    }   
    
}

extension MainTabBarControllerTransducer {
    
    enum State {
        case empty
        case loading
        case waiting
        case loaded
    }
    
    enum Trigger {
        case load(authenticated: Bool)
        case errorOccurred(authenticated: Bool)
        case rootFetched
    }
}
 
