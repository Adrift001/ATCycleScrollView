//
//  ViewController.swift
//  ATCycleScrollView
//
//  Created by Adrift001 on 04/20/2020.
//  Copyright (c) 2020 Adrift001. All rights reserved.
//

import UIKit
import ATCycleScrollView

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: ATCycleScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.imagePathsGroup = [
            "https://files.elong.work/images/051ed482f7c0df6d4bb552ca684ee070.jpg",
            "https://files.elong.work/images/7474e17a65909a0b3b5cb53becbd560b.jpg",
            "https://files.elong.work/images/731eb377705ec2b837dabef5c373fcfa.jpg",
        ]
        scrollView.pageControlBottomOffset = 15
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

