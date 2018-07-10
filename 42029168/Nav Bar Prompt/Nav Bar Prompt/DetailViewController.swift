//
//  DetailViewController.swift
//  Nav Bar Prompt
//
//  Created by Grant Butler on 7/10/18.
//  Copyright © 2018 Lickability. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    private let detailItem: NSDate
    
    init(detailItem: NSDate) {
        self.detailItem = detailItem
        
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = "Detail"
        navigationItem.prompt = "This is a prompt!"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = detailItem.description
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

}

