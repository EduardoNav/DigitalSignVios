//
//  FirmaSingleton.swift
//  FirmadoMovil
//
//  Created by Consorcio 5 on 12/07/18.
//  Copyright © 2018 Jorge Rivera. All rights reserved.
//

import UIKit

class FirmaSingleton: NSObject {
    
    static let shared = FirmaSingleton(Firma: FirmaEnt.init())
    
    var firma: FirmaEnt?
    
    private init(Firma: FirmaEnt) {
        self.firma = Firma
    }

}
