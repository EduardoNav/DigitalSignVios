//
//  FirmaSelec.swift
//  FirmadoMovil
//
//  Created by Consorcio 5 on 11/07/18.
//  Copyright © 2018 Jorge Rivera. All rights reserved.
//

import UIKit

enum keychainError: Error {
    case certificadoNoEnKeychain
    case keyNoEnKychain
    case certNotUninstalled
    case keyNotUnistalled
    case keychainEr
}

class FirmaKeychainQuery: NSObject {
    
    //Buscar Key y Cer en Keychain
    
    func buscarCer(cerLabel: String)throws{
        let getquery: [String: Any] = [kSecClass as String: kSecClassCertificate,
                                       kSecAttrLabel as String: cerLabel,
                                       kSecReturnRef as String: kCFBooleanTrue]
        let error: keychainError = .certificadoNoEnKeychain
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else {
            throw error
            
        }
    }
    
    func buscarKey(keyLabel: String)throws{
        let getquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrLabel as String: keyLabel,
                                       kSecReturnRef as String: kCFBooleanTrue]
        let error: keychainError = .keyNoEnKychain
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else {throw error}
    }
    
    // Borrar Key y Cer de Keychain
    
    func borrarCerKeychainItems(cerLabel: String)throws{
        let query: [String: Any] = [kSecClass as String: kSecClassCertificate,
                                    kSecAttrLabel as String: cerLabel,
            kSecReturnRef as String: kCFBooleanTrue]
        let status = SecItemDelete(query as CFDictionary)
        let err: keychainError = .certNotUninstalled
        guard status == errSecSuccess || status == errSecItemNotFound else { throw err }
        
    }
    
    func borrarKeyKeychainItems(keyLabel: String)throws{
        let query: [String: Any] = [kSecClass as String: kSecClassKey,
                                    kSecAttrLabel as String: keyLabel,
            kSecReturnRef as String: kCFBooleanTrue]
        let status = SecItemDelete(query as CFDictionary)
        let err: keychainError = .keyNotUnistalled
        guard status == errSecSuccess || status == errSecItemNotFound else { throw err }
    }
    
    //Obtener Cer y Key de Keychain
    
    func buscarCerAssign(cerLabel: String)throws->Any{
        let getquery: [String: Any] = [kSecClass as String: kSecClassCertificate,
                                       kSecAttrLabel as String: cerLabel,
                                       kSecReturnRef as String: kCFBooleanTrue]
        let error: keychainError = .certificadoNoEnKeychain
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else {throw error}
        let certificatequery = item as! SecCertificate
        
        return certificatequery
    }
    
    func buscarKeyAssign(keyLabel: String)throws ->Any{
        let getquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrLabel as String: keyLabel,
                                       kSecReturnRef as String: kCFBooleanTrue]
        let error: keychainError = .keyNoEnKychain
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else {throw error}
        let certificatequery = item as! SecCertificate
        
        return certificatequery
    }
    
    // Instalar Key y Cer en Keychain
    
    func guardarCerKeyDePfx(contraseña: String, pfxFile: URL, cerEtiqueta: String, keyEtiqueta: String)throws{
        let error: keychainError = .keychainEr
        do {
            
            let data = try Data.init(contentsOf: pfxFile)
            let password = contraseña
            let options = [ kSecImportExportPassphrase as String: password ]
            var rawItems : CFArray?
            
            
            var status = SecPKCS12Import(data as CFData,
                                         options as CFDictionary,
                                         &rawItems)
            
            
            guard status == errSecSuccess else {throw error}
            let items = rawItems! as! Array<Dictionary<String, Any>>
            let firstItem = items[0]
            
            let identity = firstItem[kSecImportItemIdentity as String] as! SecIdentity?
            let trust = firstItem[kSecImportItemTrust as String] as! SecTrust?
            
            var privateKey: SecKey?
            status = SecIdentityCopyPrivateKey(identity!, &privateKey)
            guard status == errSecSuccess else {throw error}
            
            
            var certificate: SecCertificate?
            status = SecIdentityCopyCertificate(identity!, &certificate)
            guard status == errSecSuccess else {throw error}
            
            
            // Se guarda la llave privada en el keychain
            let addqueryPrivateKey: [String: Any] = [kSecClass as String: kSecClassKey,
                                                     kSecValueRef as String: privateKey,
                                                     kSecAttrLabel as String: keyEtiqueta]
            status = SecItemAdd(addqueryPrivateKey as CFDictionary, nil)
            guard status == errSecSuccess else {throw error}
            
            
            // Se guarda el certificado en el keychain
            let addquery: [String: Any] = [kSecClass as String: kSecClassCertificate,
                                           kSecValueRef as String: certificate,
                                           kSecAttrLabel as String: cerEtiqueta]
            status = SecItemAdd(addquery as CFDictionary, nil)
            guard status == errSecSuccess else {throw error}
            
        } catch {
            throw error
        }
    }
    
    // Borrar todo el Keychain
    
}
