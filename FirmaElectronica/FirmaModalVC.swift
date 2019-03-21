//
//  FirmaModalVC.swift
//  FirmadoMovil
//
//  Created by Consorcio 5 on 12/07/18.
//  Copyright © 2018 Jorge Rivera. All rights reserved.
//

import UIKit

class FirmaModalVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var listaPFX: [FirmaEnt] = [FirmaEnt]()
    
    @IBOutlet weak var tablaPFX: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tablaPFX.separatorStyle = .none
        self.tablaPFX.backgroundColor = UIColor.clear
        self.obtenerArchivosDeSandbox()
        self.configureNavigationBar()
        self.validaInformacion()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validaInformacion(){
        if self.listaPFX.count == 0 {
            self.showAlert(mensaje: "No hay archivos pfx guardados en el dispositivo")
        }
    }
    
    func obtenerArchivosDeSandbox(){
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            
            for file in fileURLs {
                let pfx: FirmaEnt = FirmaEnt()
                pfx.nombrePfx = file.lastPathComponent
                pfx.getCerLabel()
                pfx.getkeyLabel()
                pfx.getInstallStatus()
                pfx.indexFile = file
                
                if pfx.nombrePfx != ".Trash"{
                    listaPFX.append(pfx)
                }
                
            }
        } catch {
            //Alerta No hay archivos
            print("No hay archivos")
        }
    }
    
    func limpiarListaPFX(){
        self.listaPFX = []
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pfxCell", for: indexPath)
        let label: UILabel = cell.viewWithTag(1) as! UILabel
        label.text = listaPFX[indexPath.row].nombrePfx
        
        if listaPFX[indexPath.row].installed == true {
            label.textColor = UIColor.green
        } else {
            label.textColor = UIColor.red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaPFX.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var tipoAlerta: UIAlertControllerStyle = .actionSheet
        if UIDevice.current.userInterfaceIdiom == .pad {
            tipoAlerta = .alert
        }
        
        let alert = UIAlertController(title: "Aviso", message: "Selecciona acción a realizar", preferredStyle: tipoAlerta)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: { (action) in
            
        }))
        
        if listaPFX[indexPath.row].installed == true{
            
            alert.addAction(UIAlertAction(title: "Seleccionar certificado", style: .default, handler: { (action) in
                
                FirmaSingleton.shared.firma = self.listaPFX[indexPath.row]
                self.dismissModalView()
                NotificationCenter.default.post(name: NSNotification.Name("FirmarCadena"), object: nil)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Desinstalar certificado", style: .default, handler: { (action) in
                
                do {
                    try self.listaPFX[indexPath.row].borrarCerDeKeychain()
                    try self.listaPFX[indexPath.row].borrarKeyDeKeyChain()
                    self.limpiarListaPFX()
                    self.obtenerArchivosDeSandbox()
                    self.tablaPFX.reloadData()
                } catch {
                    //Alerta
                }
            }))
            
        } else {
            alert.addAction(UIAlertAction(title: "Instalar certificado", style: .default, handler: { (action) in
                self.ingresarContraseña(pfx: indexPath.row)
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func ingresarContraseña(pfx: Int){
        let alertController = UIAlertController(title: "Ingresa Contraseña", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Guardar", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            
            let contraseña: String = ((firstTextField.text)!)
            
            do {
                try self.listaPFX[pfx].instalarPFX(contraseña: contraseña)
                self.limpiarListaPFX()
                self.obtenerArchivosDeSandbox()
                self.tablaPFX.reloadData()
            } catch {
                // No puedo Guardar
                self.showAlert(mensaje: "La contraseña es incorrecta")
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            
            textField.placeholder = "Contraseña"
            textField.isSecureTextEntry = true
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(mensaje: String){
        let alert = UIAlertController(title: "Aviso", message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func configureNavigationBar(){
        let barButtonDismis = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(dismissModalView))
        self.navigationItem.leftBarButtonItem = barButtonDismis
        
        self.navigationController?.navigationBar.barTintColor = UIColor.gray
        
        let frame = CGRect(x: 0, y: 0, width: 140, height: 40)
        let lblTitle = UILabel(frame: frame)
        lblTitle.text = "Lista PFX"
        lblTitle.textColor = UIColor.white
        //lblTitle.font = UIFont.boldSystemFont(ofSize: 16) //UIFont(name: "Soberana Sans", size: 17.0)
        lblTitle.font = UIFont(name: "Soberana Sans", size: 17.0)
        lblTitle.backgroundColor = UIColor.clear
        lblTitle.numberOfLines = 0
        lblTitle.adjustsFontSizeToFitWidth = true
        lblTitle.textAlignment = .center
        self.navigationItem.titleView = lblTitle
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
    }
    
    @objc func dismissModalView (){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

}
