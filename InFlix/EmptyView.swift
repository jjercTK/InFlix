//
//  EmptyView.swift
//  InFlix
//
//  Created by Juanjo on 12/14/16.
//  Copyright © 2016 Tektonlabs. All rights reserved.
//

import UIKit

class EmptyView: UIView {

    let label = UILabel()
    
    init() {
        super.init(frame: CGRect())
        
        label.text = "Nothing to display :("
        label.textColor = ColorHelper.white
        label.textAlignment = NSTextAlignment.center
        label.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        let stack = UIStackView(arrangedSubviews: [label])
        stack.axis = UILayoutConstraintAxis.vertical
        
        addSubview(stack)
        
        let horizontalConstraint = NSLayoutConstraint(item: stack, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: stack, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
