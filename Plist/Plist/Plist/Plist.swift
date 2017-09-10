//
//  Plist.swift
//  Plist
//
//  Created by aybek can kaya on 05/09/2017.
//  Copyright © 2017 aybek can kaya. All rights reserved.
//

import UIKit

enum PlistSourcePath {
    case documentsDirectory
    case bundle
}


class Plist: NSObject {
    enum PlistError:Error {
        case couldNotFetchPlistContents
        case couldNotConvertToJsonString
        case couldNotDecodeJson
        
        func errorComponent()->Error {
            switch self {
            case .couldNotConvertToJsonString:
                return NSError(domain: "could not convert json", code: 10000, userInfo: nil) as Error
            case .couldNotFetchPlistContents:
                return NSError(domain: "could not fetch plist contents", code: 10001, userInfo: nil) as Error
            case .couldNotDecodeJson:
                return NSError(domain: "could not decode json string", code: 10002, userInfo: nil) as Error
            }
        }
        
    }
    
    fileprivate var name:String = ""
    fileprivate var source:PlistSourcePath = .documentsDirectory
    fileprivate var folderPath:String = "plists"
    
    var plistPath:String {
         get{ return plistFullPath() }
    }
    
    init(_name:String , _source:PlistSourcePath = .documentsDirectory , _folderPath:String = "plists") {
        super.init()
        name = _name
        source = _source
        folderPath = _folderPath.replacingOccurrences(of: "/", with: "")
        source == .documentsDirectory ? createPlist() : copyFromBundle()
    }
    
    private func createPlist() {
        let fullPath:String = plistFullPath()
        guard !fullPath.fileExistAtPath() else { return }
        folderPath.createDir()
        let emptyDct = NSDictionary(dictionary: [:])
        emptyDct.write(toFile: fullPath, atomically: true)
 }
    
    private func plistFullPath()->String {
        return String.documentsDirectoryPath()+"/"+folderPath+"/"+name+".plist"
    }
    
    private func copyFromBundle() {
        let fullname = name+".plist"
        guard !plistPath.fileExistAtPath() else { return }
        folderPath.createDir()
        guard let documentsURL = Bundle.main.resourceURL?.appendingPathComponent(fullname) else { return }
        do {
            try FileManager.default.copyItem(atPath: (documentsURL.path), toPath: plistPath)
        } catch let error as NSError {
            print("Error:\(error.description)")
        }
        
    }
    
    fileprivate func contents()->[String:Any]? {
        let path = plistFullPath()
        guard let dct = NSDictionary(contentsOfFile: path) as? [String: Any] else { return nil }
        return dct
    }
    
    func save(key:String , data:Any , completion:@escaping (_ error:Error?)->Void) {
        guard var contentsList = contents() else {
            completion(PlistError.couldNotFetchPlistContents.errorComponent())
            return
        }
        let dct:[String:Any] = [key:data]
        guard let jsonStr = dct.toJsonString() else {
            completion(PlistError.couldNotConvertToJsonString.errorComponent())
            return
        }
        contentsList[key] = jsonStr
        DispatchQueue.global(qos: .background).async {
            (contentsList as NSDictionary).write(toFile: self.plistFullPath(), atomically: true)
            DispatchQueue.main.async {
               completion(nil)
            }
        }
       
    }
    
    func read(key:String , completion:@escaping(_ data:[String:Any]? , _ error:Error?)->Void) {
        
        DispatchQueue.global(qos: .background).async {
            let path = self.plistFullPath()
            guard let dct = NSDictionary(contentsOfFile: path) as? [String: Any] else {
                DispatchQueue.main.async {
                    completion(nil, PlistError.couldNotFetchPlistContents.errorComponent())
                }
                return
            }
            guard let content = dct[key] as? String else {
                DispatchQueue.main.async {
                    completion(nil, nil)
                }
                return
            }
            
            guard let json = content.decodeJSON() else {
                completion(nil, PlistError.couldNotDecodeJson.errorComponent())
                return
                
            }
            completion(json, nil)
        }
    
    }
    

    func removePlist() {
      
        let fullPath:String = plistFullPath()
        guard fullPath.fileExistAtPath() else { return }
        fullPath.removeFile()
    }
    
    static func allPlistFiles(directoryName:String)->[String] {
        let allFiles:[String] = directoryName.allFilesInDirectory()
        return allFiles.map{ $0.components(separatedBy: "/").last! }.filter{element in
            let ext = element.components(separatedBy: ".").last!
            return ext == "plist"
            }.map{ $0.components(separatedBy: ".").first! }
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
    
    func decodeJSON()->[String:Any]? {
        guard let data = self.data(using: String.Encoding.utf8) else { return nil }
        do{
            let jsonParsed = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            return jsonParsed as? [String:Any]
        }catch {
            print("err: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func documentsDirectoryPath()->String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    }
    
    func fileExistAtPath()->Bool {
        return FileManager.default.fileExists(atPath: self)
    }
    
    func directoryExists()->Bool {
        let fileManager = FileManager.default
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: self, isDirectory:&isDir) {
            if isDir.boolValue {
                // file exists and is a directory
                return true
            } else {
                // file exists and is not a directory
                fatalError("String:\(self) is not a directory path")
            }
        }
      return false
    }
    
   
    
    func removeFile() {
        do {
           try FileManager.default.removeItem(atPath: self)
        }catch {
            print("error : \(error.localizedDescription)")
        }
    }
    
    
    func allFilesInDirectory()->[String] {
       
         var documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
         documentsUrl.appendPathComponent(self)
        var contents:[String] = []
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            contents = directoryContents.map{ $0.absoluteString }
            return contents
        } catch  {
            return contents
        }
    }
    
    
    func createDir() {
        guard !self.directoryExists() else { return }
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let pt = self+"/"
        let dataPath = documentsDirectory.appendingPathComponent(pt)
        
        do {
            try FileManager.default.createDirectory(at: dataPath, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print("Error creating directory: \(error.localizedDescription)")
        }
    }
    
}





