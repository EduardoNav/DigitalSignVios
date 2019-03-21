//
//  FirmaSingleton.swift
//  FirmadoMovil
//
//  Created by Luis Eduardo Moreno Nava on 12/07/18.
//  Copyright © 2018 Luis Eduardo Moreno Nava. All rights reserved.
//

import UIKit

class FirmaSingleton: NSObject {
    
    static let shared = FirmaSingleton(Firma: FirmaEnt.init())
    
    var firma: FirmaEnt?
    
    private init(Firma: FirmaEnt) {
        self.firma = Firma
    }

}
