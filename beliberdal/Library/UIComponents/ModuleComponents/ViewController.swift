//
//  ViewController.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 18.08.2021.
//

import UIKit

class ViewController<View: UIView>: UIViewController {
    
    private(set) lazy var mainView = View()
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
}

