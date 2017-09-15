# Plist

Plist is an asynchronous property list manager that is written in Swift.  Main features includes: 
* Creating property list 
* Copying any property list from app’s bundle to documents directory
* Save any data with key asynchronously 
* Read any data as dictionary asynchronously
* Listing all plist files in documents directory 


## Getting Started

Download the project and copy the PlistSwift folder into your project and then simply you can use it in any file




``` swift
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

```

### Prerequisites

* Swift 3.0+ 
* Xcode 8.0+
* iOS 10.0+


## Running the tests

Run tests by cmd+U in Xcode


License
--------


    Copyright 2017 Aybek Can Kaya.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

