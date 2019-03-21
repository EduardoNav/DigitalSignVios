//
//  FirmarVC.swift
//  FirmadoMovil
//
//  Created by Consorcio 5 on 12/07/18.
//  Copyright © 2018 Jorge Rivera. All rights reserved.
//

import UIKit

class FirmarVC: UIViewController {
    
    var cadenaFirmada: String = ""
    var cadenaOriginal: String = ""
    var certificadoVerificar: SecCertificate? = nil
    var privateKeyVerificar: SecKey? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func firmarCadena(_ sender: Any) {
        self.presentModalViewController("FirmaModal", ViewControllerNameID: "FirmaModalVC")
    }
    
    @IBAction func metodoPruba(_ sender: Any){
        self.cadenaOriginal = "1||2||3||4||5"
        self.firmar(cadena: self.cadenaOriginal)
    }
    
    func firmarCadenaOriginal(cadenaOrigen: String){
        self.cadenaOriginal = cadenaOrigen
        self.firmar(cadena: self.cadenaOriginal)
    }
    
    func firmar(cadena:String) {
        do {
            self.cadenaFirmada = try KriptoManager().firmarCadena(cadena: cadena, keylabel: (FirmaSingleton.shared.firma?.nombreKeyLabel)!)
            print(self.cadenaFirmada)
            self.certificadoVerificar = try FirmaKeychainQuery().buscarCerAssign(cerLabel: (FirmaSingleton.shared.firma?.nombreCerLabel)!) as! SecCertificate
            self.privateKeyVerificar = try FirmaKeychainQuery().buscarKeyAssign(keyLabel: (FirmaSingleton.shared.firma?.nombreKeyLabel)!) as! SecKey
            self.presentViewController()
        } catch {
            //Alerta
        }
    }
    
    func presentViewController(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "FirmaModal", bundle: nil)
        let viewController: ResultadosVC
        viewController = storyBoard.instantiateViewController(withIdentifier:"ResultadosVC") as! ResultadosVC
        viewController.cadenaConcatenada = self.cadenaOriginal
        viewController.firmaFalsa = self.cadenaFirmada
        viewController.privateKeyVerificar = self.privateKeyVerificar
        viewController.certificadoVerificar = self.certificadoVerificar
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentModalViewController(_ StoryboardName: String, ViewControllerNameID: String){
        let storyBoard = UIStoryboard(name: StoryboardName, bundle: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: ViewControllerNameID)
        let nv: UINavigationController  = UINavigationController(rootViewController: vc)
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone{
            nv.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        }else if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad{
            nv.modalPresentationStyle = UIModalPresentationStyle.formSheet
        }
        
        self.present(nv, animated: true, completion:nil)
    }
    
}
