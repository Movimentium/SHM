//
//  SHMDataProvider.swift
//  SHM
//
//  Created by Miguel on 29/09/2020.
//  Copyright © 2020 Miguel Gallego Martín. All rights reserved.
//

import Foundation

class SHMDataProvider {
   
    static let single = SHMDataProvider()
    private init() {}
    
    var response: CharacterResponse?
    
}
