//
//  PlistTests.swift
//  PlistTests
//
//  Created by aybek can kaya on 05/09/2017.
//  Copyright © 2017 aybek can kaya. All rights reserved.
//

import XCTest
@testable import Plist

class PlistTests: XCTestCase {
    
    fileprivate let sampleListName:String = "sampleList"
    fileprivate let sampleFolderName:String = "sampleFolder"
    fileprivate let sampleListNameBundle:String = "sampleListFromBundle"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
       // let list = Plist(_name: sampleListName , _source: .documentsDirectory, _folderPath:sampleFolderName)
        //list.removePlist()
    }
    
    func testCreatePlist() {
        let _ = Plist(_name: sampleListName , _source: .documentsDirectory, _folderPath:sampleFolderName)
        let files:[String] = sampleFolderName.allFilesInDirectory().map{
            $0.components(separatedBy: "/").last!
            }.map{
                $0.components(separatedBy: ".").first!
        }
        XCTAssert(files.contains(sampleListName))
    }
    
    func testInitializePlistFromName() {
        
        let list = Plist(_name: sampleListName, _source: .documentsDirectory, _folderPath: sampleFolderName)
        let allFiles:[String] = Plist.allPlistFiles(directoryName: sampleFolderName)
        XCTAssert(allFiles.contains(sampleListName))
        
    }
    
    func testCopyPlistFromBundle() {
         let expect = expectation(description: "Plist copy from bundle")
        let list = Plist(_name: sampleListNameBundle, _source: .bundle, _folderPath: sampleFolderName)
         let allFiles:[String] = Plist.allPlistFiles(directoryName: sampleFolderName)
        XCTAssert(allFiles.contains(sampleListNameBundle))
        list.read(key: "team") { (data, error) in
            XCTAssert(error == nil )
            guard let theData = data else {
                XCTAssert(data != nil)
                return
            }
            guard let dct = theData["team"] as? [String:Any] , let name = dct["name"] as? String else {
                XCTFail()
                return
            }
            XCTAssert(name == "besiktas")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 4.0) { (_) -> Void in
        }
    }
    
    func testSaveDataToPlist() {
        let expect = expectation(description: "Saving fullfill")
        let list = Plist(_name: sampleListName , _source: .documentsDirectory, _folderPath:sampleFolderName)
        let dataToSave:[String : Any] = ["name":"cristiano" , "surname" : "ronaldo"]
        list.save(key: "football", data: dataToSave) { error in
             XCTAssert(error == nil )
            list.read(key: "football", completion: { (data, error) in
               
                XCTAssert(error == nil )
                guard let theData = data else {
                    XCTAssert(data != nil)
                    return
                }
                guard let dct = theData["football"] as? [String:Any] , let name = dct["name"] as? String else {
                    XCTFail()
                    return
                }
                XCTAssert(name == "cristiano")
                expect.fulfill()
            })
        }
        
        waitForExpectations(timeout: 4.0) { (_) -> Void in
        }
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
