//
//  CustomSearchController.swift
//  InFlix
//
//  Created by Juanjo on 12/2/16.
//  Copyright © 2016 Tektonlabs. All rights reserved.
//

import UIKit

class CustomSearchController: UISearchController {
    
    var customSearchBar: CustomSearchBar!
    
    init(searchResultsController: UIViewController!,
         searchBarFrame: CGRect,
         searchBarFont: UIFont,
         searchBarTextColor: UIColor,
         searchBarTintColor: UIColor) {
        
        super.init(searchResultsController: searchResultsController)
        
        configureSearchBar(frame: searchBarFrame, font: searchBarFont, textColor: searchBarTextColor, bgColor: searchBarTintColor)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureSearchBar(frame: CGRect, font: UIFont, textColor: UIColor, bgColor: UIColor) {
        customSearchBar = CustomSearchBar(frame: frame, font: font , textColor: textColor)
        
        customSearchBar.barTintColor = bgColor
        customSearchBar.tintColor = textColor
        customSearchBar.showsBookmarkButton = false
        customSearchBar.showsCancelButton = false
        customSearchBar.showsScopeBar = true
        
    }


}
