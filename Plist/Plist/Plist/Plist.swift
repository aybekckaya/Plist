//
//  Plist.swift
//  Plist
//
//  Created by aybek can kaya on 05/09/2017.
//  Copyright © 2017 aybek can kaya. All rights reserved.
//

import UIKit

/**
 *** Specs
 ** Bundle içerisinden bir plisti okuma ve ilk okumada folderpath içerisine aynı isim ile kaydetme.
 
 *** constants :
 **  folderPath // plist dosyalarının bulunacağı yer. Eğer böyle bir dosya yeri yok ise ilk save yapıldığında herhangi bir plist burası yaratılır.
 
 *** variables:
 enum SourcePath{ case documentsDirectory , case bundle }
 
 *** init(name:String , source:SourcePath = .documentsDir) : name ile verilen dosya yolunda plist aranır . Eğer bulunamazsa yeni yaratılır ilk save veya read yapıldığı anda.
 Eğer sourcePath bundle ise documentsDir içinde bu plist aranır. Eğer bulunmazsa bundle içinden plist okunur ve içindekiler documents içine kaydedilir.
 
 *** save(val:Any , key:String , completion:()->Void) : plist içerisine async şekilde content json a dönüştürülerek yazılır. Yani varolan contente append yapılır. jsona çevrim yapılamazsa error handling olacak.
 
 *** delete(key:String , completion:()->Void? = nil ) : plist içerisinden ilgili key async şekilde silinir.
 
 *** removePlist() : plist tümüyle silinir.
 
 *** read(key:String , completion:(dctContent:[String:Any]? , error:Error?)->Void) : ilgili key okunur ve sonuçlar dctContents içerisinde döndürülür. dct content -> key(parametre olarak verilen key) , value:(json parsed value type Any )
 
 *** readAll(completion:(dctContent:[String:Any]? , error:Error?)->Void) : Plist içerisindeki tüm data döndürülür.
 
 *** static allLists()->[Plist] : folder içerisindeki tüm listeleri döndürür.

 */


enum PlistSourcePath {
    case documentsDirectory
    case bundle
}

class Plist: NSObject {

    fileprivate var name:String = ""
    fileprivate var source:PlistSourcePath = .documentsDirectory
    fileprivate var folderPath:String = "/plists/"
    
    init(_name:String , _source:PlistSourcePath = .documentsDirectory , _folderPath:String = "/plists/") {
        super.init()
        name = _name
        source = _source
        folderPath = _folderPath
        source == .documentsDirectory ? createPlist() : copyFromBundle()
    }
    
    private func createPlist() {
       /*
        let fileManager = FileManager.default
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = documentDirectory.appending("/profile.plist")
         */
        
        
 }
    
    private func copyFromBundle() {
        
    }
    
}

protocol JsonConvertible {
    func toJsonString()->String?
}

extension JsonConvertible {
    func toJsonString()->String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
            return jsonString
        } catch {
            return nil
        }
    }
}

extension Array:JsonConvertible {}
extension Dictionary:JsonConvertible {}



extension String {
    static func documentsDirectoryPath()->String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    }
    
    
    func fileExistAtPath()->Bool {
        return FileManager.default.fileExists(atPath: self)
    }
}





