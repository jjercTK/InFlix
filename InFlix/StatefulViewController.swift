//
//  StatefulViewController.swift
//  InFlix
//
//  Created by Juanjo on 12/7/16.
//  Copyright © 2016 Tektonlabs. All rights reserved.
//

import UIKit

enum ViewControllerState {
    case Error
    case Empty
    case Loading
    case Content
}

protocol BackingViewProvider {
    var backingView: UIView { get }
}

protocol StatefulViewController: class, BackingViewProvider {
    
    weak var loadingStateView: UIView? {get set}
    weak var emptyStateView: UIView? {get set}
    weak var errorStateView: UIView? {get set}
    
    var currentState: ViewControllerState {get set}
    
    func hasContent() -> Bool
    func startLoading()
    func endLoading(withError error:Error?)
    func placeholderViewConstraints() -> [NSLayoutConstraint]
}

