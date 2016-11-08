//
//  FavoriteCellDelegate.swift
//  InFlix
//
//  Created by Juanjo on 11/7/16.
//  Copyright © 2016 Tektonlabs. All rights reserved.
//

import UIKit

protocol FavoriteCellDelegate {
    func favoriteCell(_ favoriteCell: MovieTableViewCell, didToogleButton toogle: Bool)
}
