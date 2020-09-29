//
//  LandingVC.swift
//  SHM
//
//  Created by Miguel on 29/09/2020.
//  Copyright © 2020 Miguel Gallego Martín. All rights reserved.
//

import UIKit

class LandingVC: UIViewController, LandingViewInterface {

    
    private let presenter = LandingPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewInterface = self
        setupUI()
    }
    
    func setupUI() {
        
    }
    
    // MARK: - LandingViewInterface

    func nada() {
         
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
