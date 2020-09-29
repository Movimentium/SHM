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
    

    func llamar() {
        NetRequest.characters.resumeTask { (isSuccess, strError, data) in
        
            
 
            
            
        }

    }
//    NetRequest.transactions.resumeTask { [weak self] (isSuccess, strError, data) in
//        if let _ = data, isSuccess {
//            self?.arrRawTransactions = try? JSONDecoder().decode([Transaction].self, from: data!)
//            self?.debug_arrRawTransactions()
//            self?.proccessArrRawTransactions()
//        } else {
//            self?.isUpdatingTransactionList = false
//            print("ERROR \(String(describing: TransactionsInteractor.self)) \(#function)")
//        }
//    }

    
    
}
