//
//  DollarDecode.swift
//  DollarRatesApp
//
//  Created by Ксения Салфетникова on 14.07.2021.
//

import UIKit
import SWXMLHash

class DollarDecode: NSObject {

    class func decode(from data: XMLIndexer) -> [Dollar] {
        var dollarRates: [Dollar] = []
        let dataArray = data["ValCurs"]["Record"]
        for index in 0...dataArray.all.count - 1 {
            let date = dataArray[index].element?.attribute(by: "Date")?.text ?? ""
            let rate = dataArray[index]["Value"].element?.text ?? ""
            let dollar = Dollar(rate: rate, date: DateHelper.dateFromString(date))
            dollarRates.append(dollar)
        }
        return dollarRates
    }
}
