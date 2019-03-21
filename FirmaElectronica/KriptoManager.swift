//
//  KriptoManager.swift
//  FirmadoMovil
//
//  Created by Consorcio 5 on 15/07/18.
//  Copyright © 2018 Jorge Rivera. All rights reserved.
//

import UIKit

class KriptoManager: NSObject {
    
    func firmarCadena(cadena:String, keylabel: String)throws->String{
        
        //let certificado: SecCertificate = try FirmaKeychainQuery().buscarCerAssign(cerLabel: cerlabel) as! SecCertificate
        let privateKey: SecKey = try FirmaKeychainQuery().buscarKeyAssign(keyLabel: keylabel) as! SecKey
        var error: Unmanaged<CFError>?
        
        //firmar con la llave primaria
        //let algorithm: SecKeyAlgorithm = .rsaSignatureMessagePKCS1v15SHA512
        let algorithm: SecKeyAlgorithm = .rsaSignatureMessagePKCS1v15SHA256
        guard SecKeyIsAlgorithmSupported(privateKey, .sign, algorithm) else {
            throw (error?.takeRetainedValue())!
        }
        
        let dataToSign: Data? = cadena.data(using: String.Encoding.utf8)
        guard let signature = SecKeyCreateSignature(privateKey,
                                                    algorithm,
                                                    dataToSign! as CFData,
                                                    &error) as Data? else {
                                                        throw (error?.takeRetainedValue())!
        }
        
        let signedData = signature as Data
        let signedString = signedData.base64EncodedString(options: [])
        
        return signedString
    }
    
    func verificarFirma(privateKeyVerificar: SecKey, original: String, firmado: String)->String{
        
        //let algorithm: SecKeyAlgorithm = .rsaSignatureMessagePKCS1v15SHA512
        let algorithm: SecKeyAlgorithm = .rsaSignatureMessagePKCS1v15SHA256
        let publicKey = SecKeyCopyPublicKey(privateKeyVerificar)
        var error: Unmanaged<CFError>?
        let messageData = original.data(using: String.Encoding.utf8)
        guard let signatureData = Data(base64Encoded: firmado, options: []) else {return "NO VÁLIDO"}
        
        guard SecKeyVerifySignature(publicKey!,
                                    algorithm,
                                    messageData! as CFData,
                                    signatureData as CFData,
                                    &error) else {
                                        return "NO VÁLIDO"
        }
        return "VÁLIDO"
    }

}
