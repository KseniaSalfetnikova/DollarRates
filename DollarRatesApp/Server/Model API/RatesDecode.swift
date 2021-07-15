//
//  RatesDecode.swift
//  DollarRatesApp
//
//  Created by Ксения Салфетникова on 15.07.2021.
//

import UIKit
import SWXMLHash

class RatesDecode: NSObject {

    class func decode(from data: XMLIndexer) -> Dollar? {
        let dataArray = data["ValCurs"]["Valute"]
        let date = data["ValCurs"].element?.attribute(by: "Date")?.text ?? ""
        for index in 0...dataArray.all.count - 1 {
            let number = dataArray[index].element?.attribute(by: "ID")?.text ?? ""
            let rate = dataArray[index]["Value"].element?.text ?? ""
            if number == "R01235" {
                return Dollar(rate: rate, date: DateHelper.dateFromString(date))
            }
        }
        return nil
    }
}
