//
//  Requests.swift
//  DollarRatesApp
//
//  Created by Ксения Салфетникова on 14.07.2021.
//

import UIKit

class Requests: NSObject {
    fileprivate let mounthAdditionalAddress = "/XML_dynamic.asp"
    fileprivate let dayAdditionalAddress = "/XML_daily.asp"

    func mounthDollarRate(completion: @escaping ([Dollar]) -> Void) {
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(-31 * 24 * 60 * 60)
        let parameters = [
            "date_req1": DateHelper.shortServerDate(from: endDate),
            "date_req2": DateHelper.shortServerDate(from: startDate),
            "VAL_NM_RQ": "R01235"
        ]

        ServerManager.shared.getRequest(additionalAddress: mounthAdditionalAddress, parameters: parameters) { xml in
            if let xml = xml {
                let dollarsArray = DollarDecode.decode(from: xml)
                completion(dollarsArray)
            } else {
                completion([])
            }
        }
    }

    func currentDollarRate(completion: @escaping (Dollar) -> Void) {
        let parameters = [
            "date_req": "14/07/2021"//DateHelper.shortServerDate(from: Date()),
            //"VAL_NM_RQ": "R01235"
        ]

        ServerManager.shared.getRequest(additionalAddress: dayAdditionalAddress, parameters: nil) { xml in
            if let xml = xml,
               let dollarRate = RatesDecode.decode(from: xml) {
                completion(dollarRate)
            } else {
                completion(Dollar(rate: "0", date: Date()))
            }
        }
    }

}
