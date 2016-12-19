//
//  StatefulViewControllerImplementation.swift
//  InFlix
//
//  Created by Juanjo on 12/12/16.
//  Copyright © 2016 Tektonlabs. All rights reserved.
//

import UIKit

extension BackingViewProvider where Self: UIViewController {
    var backingView: UIView {
        return view
    }
}

extension BackingViewProvider where Self: UIView {
    var backingView: UIView {
        return self
    }
}

extension StatefulViewController {
    
    var currentView: UIView? {
        switch currentState {
        case .Content:
            return nil
        case .Error:
            return errorStateView
        case .Empty:
            return emptyStateView
        case .Loading:
            return loadingStateView
        }
    }
    
    func hasContent() -> Bool {
        return true
    }
    
    func startLoading(){
        changeState(to: .Loading)
    }
    
    func changeState(to state: ViewControllerState){
        currentView?.removeFromSuperview()
        currentState = state
        if let currentView = currentView {
            backingView.addSubview(currentView)
            currentView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(placeholderViewConstraints())
        }
    }
    
    func endLoading(withError error:Error?){
        
        if let _ = error {
            changeState(to: .Error)
            return
        }
        
        if hasContent() {
             changeState(to: .Content)
        } else {
            changeState(to: .Empty)
        }
        
    }
    
}
