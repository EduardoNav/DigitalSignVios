//
//  FirmarVC.swift
//  FirmadoMovil
//
//  Created by Luis Eduardo Moreno Nava on 12/07/18.
//  Copyright © 2018 Luis Eduardo Moreno Nava. All rights reserved.
//

import UIKit

public class FirmarVC: UIViewController {
    
    public var cadenaFirmada: String = ""
    public var cadenaOriginal: String = ""
    public var certificadoVerificar: SecCertificate? = nil
    public var privateKeyVerificar: SecKey? = nil
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
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
    
    public func firmarCadenaOriginal(cadenaOrigen: String){
        self.cadenaOriginal = cadenaOrigen
        self.firmar(cadena: self.cadenaOriginal)
    }
    
    public func firmar(cadena:String) {
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
    
    public func presentViewController(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "FirmaModal", bundle: nil)
        let viewController: ResultadosVC
        viewController = storyBoard.instantiateViewController(withIdentifier:"ResultadosVC") as! ResultadosVC
        viewController.cadenaConcatenada = self.cadenaOriginal
        viewController.firmaFalsa = self.cadenaFirmada
        viewController.privateKeyVerificar = self.privateKeyVerificar
        viewController.certificadoVerificar = self.certificadoVerificar
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    public func presentModalViewController(_ StoryboardName: String, ViewControllerNameID: String){
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
