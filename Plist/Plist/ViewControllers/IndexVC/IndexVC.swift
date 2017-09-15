//
//  IndexVC.swift
//  Plist
//
//  Created by aybek can kaya on 05/09/2017.
//  Copyright © 2017 aybek can kaya. All rights reserved.
//

import UIKit

class IndexVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // creating plist at /documentsFolder/plistPath/myPlist.plist
        let list = Plist(_name: "myList", _source: .documentsDirectory, _folderPath: "plistPath")
        
        //copy list from bundle to documents folder
        let listAtBundle = Plist(_name: "myListAtBundle", _source: .bundle, _folderPath: "plistPath")
        
        // save data to plist
        let data:[String:Any] = ["name" : "forest" , "surname":"gump" , "id":132]
        list.save(key: "myKey", data: data) { error in
            print("error : \(error)")
        }
        
        // read data from list
        list.read(key: "myKey") { (data, error) in
            guard error == nil else {
                print("error : \(error)")
                return
            }
        }
        
        // remove value with key
        list.removeKey(key: "myKey")
        
        //remove Plist from documents directory
        list.removePlist()
        
        //all plists' names from given folder at documents directory
        let allLists = Plist.allPlistFiles(directoryName: "plistPath")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
