//
//  FirmaEnt.swift
//  FirmadoMovil
//
//  Created by Luis Eduardo Moreno Nava on 11/07/18.
//  Copyright © 2018 Luis Eduardo Moreno Nava. All rights reserved.
//

import UIKit

public enum firmaError: Error {
    case unManagedError
    case noSuchfile
    case intalledError
    case borrarError
    case obtenerError
}

public class FirmaEnt: NSObject {
    
    public var nombrePfx: String?
    public var nombreCerLabel: String?
    public var nombreKeyLabel: String?
    public var installed: Bool?
    public var indexFile: URL?
    
    public init(NombrePfx: String, NombreCerLabel: String, NombreKeyLabel: String, Installed: Bool, IndexFile: URL) {
        super.init()
        self.nombrePfx = NombrePfx
        self.nombreCerLabel = NombreCerLabel
        self.nombreKeyLabel = NombreKeyLabel
        self.installed = Installed
        self.indexFile = IndexFile
    }
    
    public override init() {
        super.init()
        self.nombrePfx = ""
        self.nombreCerLabel = ""
        self.nombreKeyLabel = ""
        self.installed = false
        self.indexFile = URL.init(string: "")
    }
    
    public func getCerLabel(){
        if let nombreLabel = self.nombrePfx{
            self.nombreCerLabel = nombreLabel.replacingOccurrences(of: ".pfx", with: "")
        }
    }
    
    public func getkeyLabel(){
        if let nombreLabel = self.nombrePfx{
            self.nombreKeyLabel = nombreLabel.replacingOccurrences(of: ".pfx", with: "")
        }
    }
    
    public func getInstallStatus(){
        
        self.installed = false
        let cerInstall: Bool = self.cerInKeychain()
        let keyInstall: Bool = self.keyInKeyChain()
        
        if cerInstall && keyInstall == true {
            self.installed = true
        }
    }
    
    
    //Buscar
    public func cerInKeychain()->Bool{
        do {
            if let nom = nombreCerLabel {
                try FirmaKeychainQuery().buscarCer(cerLabel: nom)
            } else {
                return false
            }
            
        } catch {
            return false
        }
        return true
    }
    
    public func keyInKeyChain()->Bool{
        do {
            if let nom = nombreKeyLabel {
                try FirmaKeychainQuery().buscarKey(keyLabel: nom)
            } else {
                return false
            }
            
        } catch {
            return false
        }
        return true
    }
    
    //Borrar
    public func borrarCerDeKeychain()throws{
        let errorCer: firmaError = .borrarError
        do {
            try FirmaKeychainQuery().borrarCerKeychainItems(cerLabel: nombreCerLabel!)
        } catch {
            throw errorCer
        }
    }
    
    public func borrarKeyDeKeyChain()throws{
        let errorKey: firmaError = .borrarError
        do {
            try FirmaKeychainQuery().borrarKeyKeychainItems(keyLabel: nombreKeyLabel!)
        } catch {
            throw errorKey
        }
    }
    
    //Instalar 
    public func instalarPFX(contraseña: String)throws{
        let errorFileFound: firmaError = .noSuchfile
        let errorInstalar: firmaError = .intalledError
        
        if let pfxFileLoc = indexFile {
            
            do {
                try FirmaKeychainQuery().guardarCerKeyDePfx(contraseña: contraseña, pfxFile: pfxFileLoc, cerEtiqueta: nombreCerLabel!, keyEtiqueta: nombreKeyLabel!)
            } catch {
                throw errorInstalar
            }
            
        } else {
            throw errorFileFound
        }
    }
    
    //Obtener Directo de FirmaKeychainQuery 
    
}
