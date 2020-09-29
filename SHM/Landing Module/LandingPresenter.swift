//
//  LandingPresenter.swift
//  SHM
//
//  Created by Miguel on 29/09/2020.
//  Copyright © 2020 Miguel Gallego Martín. All rights reserved.
//

import UIKit

protocol LandingViewInterface: AnyObject {
    func nada()
}

class LandingPresenter {
    weak var viewInterface: LandingViewInterface?
}
