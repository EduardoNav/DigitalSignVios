//
//  ResultadosVC.swift
//  FirmadoMovil
//
//  Created by Luis Eduardo Moreno Nava on 12/07/18.
//  Copyright © 2018 Luis Eduardo Moreno Nava. All rights reserved.
//

import UIKit

class ResultadosVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var scrollVerificar: UIScrollView!
    
    @IBOutlet weak var original: UITextView!
    
    @IBOutlet weak var firmado: UITextView!
    
    var cadenaConcatenada : String = ""
    var firmaFalsa : String = ""
    var certificadoVerificar: SecCertificate? = nil
    var privateKeyVerificar: SecKey? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTittle()
        self.configTextView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configTextView(){
        self.original.text = self.cadenaConcatenada
        self.original.tag = 1
        self.firmado.text = self.firmaFalsa
        self.firmado.tag = 2
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-130, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func configTittle(){
        let frame = CGRect(x: 0, y: 0, width: 140, height: 40)
        let lblTitle = UILabel(frame: frame)
        lblTitle.text = "Cadena Firmada"
        lblTitle.textColor = UIColor.white
        //lblTitle.font = UIFont.boldSystemFont(ofSize: 16) //UIFont(name: "Helvetica", size: 17.0)
        lblTitle.font = UIFont(name: "Soberana Sans", size: 17.0)
        lblTitle.backgroundColor = UIColor.clear
        lblTitle.numberOfLines = 0
        lblTitle.adjustsFontSizeToFitWidth = true
        lblTitle.textAlignment = .center
        self.navigationItem.titleView = lblTitle
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.tag == 2 {
            var punto:CGPoint
            punto=CGPoint(x:0, y:textView.frame.origin.y-240)
            self.scrollVerificar.setContentOffset(punto, animated: true)
        }
    }
    
    /* Updated for Swift 4 */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    /* Older versions of Swift */
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.tag == 2 {
            var punto:CGPoint
            punto=CGPoint(x:0, y:textView.frame.origin.y-100)
            self.scrollVerificar.setContentOffset(punto, animated: true)
        }
    }
    
    func verificarFirma()->String{
        
        return KriptoManager().verificarFirma(privateKeyVerificar: privateKeyVerificar!, original: original.text, firmado: firmado.text)
        
    }
    
    @IBAction func verificar(_ sender: Any) {
        showToast(message: verificarFirma())
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
