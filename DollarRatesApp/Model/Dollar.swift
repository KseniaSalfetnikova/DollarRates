//
//  Dollar.swift
//  DollarRatesApp
//
//  Created by Ксения Салфетникова on 14.07.2021.
//

import UIKit

class Dollar: NSObject {
    let rate: String
    let date: Date

    init(rate: String, date: Date) {
        self.rate = rate
        self.date = date
    }

}
