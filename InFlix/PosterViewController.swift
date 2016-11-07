//
//  PosterViewController.swift
//  InFlix
//
//  Created by Juanjo on 11/7/16.
//  Copyright © 2016 Tektonlabs. All rights reserved.
//

import UIKit

class PosterViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: Properties
    
    private var posterView = UIImageView()
    
    var poster: UIImage? {
        get {
            return posterView.image
        }
        set {
            posterView.image = newValue
            posterView.sizeToFit()
            scroller?.contentSize = posterView.frame.size
        }
    }
    @IBOutlet weak var scroller: UIScrollView! {
        didSet {
            scroller.contentSize = posterView.frame.size
            scroller.delegate = self
            scroller.minimumZoomScale = 0.03
            scroller.maximumZoomScale = 1.0
        }
    }
    
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scroller.addSubview(posterView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return posterView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
