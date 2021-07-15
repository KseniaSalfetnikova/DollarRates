//
//  ServerManager.swift
//  DollarRatesApp
//
//  Created by Ксения Салфетникова on 14.07.2021.
//

import UIKit
import Alamofire
import SWXMLHash

class ServerManager: NSObject {

    fileprivate let mainAddress = "http://www.cbr.ru/scripts"

    static var shared: ServerManager = {
        let instance = ServerManager()
        return instance
    }()

    func getRequest(additionalAddress: String, parameters: [String: String]?, completion: @escaping (XMLIndexer?) -> Void) {
        guard let url = URL(string: "\(mainAddress)\(additionalAddress)") else {
            return completion(nil)
        }
        let request = AF.request(url, method: .get, parameters: parameters)
        request.response { data in
            guard let dataString = String(data: data.data!, encoding: .ascii) else {
                return completion(nil)
            }
            let xml = SWXMLHash.parse(dataString)
            completion(xml)
        }
    }

}
