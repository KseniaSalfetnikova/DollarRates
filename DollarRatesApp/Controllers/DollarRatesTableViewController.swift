//
//  DollarRatesTableViewController.swift
//  DollarRatesApp
//
//  Created by Ксения Салфетникова on 14.07.2021.
//

import UIKit

class DollarRatesTableViewController: UITableViewController {

    fileprivate let dollarRateCellReuseIdentifier = "Dollar rate cell"
    fileprivate var rates: [Dollar] = []
    fileprivate let lastCheckDateKey = "lastDate"
    fileprivate let globalRateKey = "globalRate"
    fileprivate lazy var requests = Requests()
    fileprivate var globalRate = "0"

    override func viewDidLoad() {
        super.viewDidLoad()
        let userPreference = UserDefaults.standard
        if let lastGlobalRate: String = userPreference.string(forKey: globalRateKey) {
            globalRate = lastGlobalRate
        }
        loadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rates.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: dollarRateCellReuseIdentifier, for: indexPath)
        let date = DateHelper.shortUserDate(from: rates[indexPath.row].date)
        cell.textLabel?.text = "\(date):  \(rates[indexPath.row].rate)"
        return cell
    }

    // MARK: - Private API

    fileprivate func loadData() {
        requests.mounthDollarRate { dollarRates in
            self.rates = dollarRates
            self.tableView.reloadData()
            self.checkCurrentRate()
        }
    }

    fileprivate func checkCurrentRate() {
        requests.currentDollarRate { dollar in
            let userPreference = UserDefaults.standard
            if let lastDate: String = userPreference.string(forKey: self.lastCheckDateKey) {
                if DateHelper.shortUserDate(from: dollar.date) == lastDate { return }
            }
            if dollar.rate > self.globalRate {
                userPreference.setValue(DateHelper.shortUserDate(from: dollar.date), forKey: self.lastCheckDateKey)
                self.showAlert()
            }
        }
    }

    fileprivate func showAlert() {
        let alert = UIAlertController(title: "Доллар выше \(self.globalRate) руб.!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Actions

    @IBAction fileprivate func editGlobalRate(_ sender: Any) {
        let alert = UIAlertController(title: "Введите значение", message: "С ним будет сравниваться текущий курс", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))

        alert.addTextField { textField in
            textField.placeholder = self.globalRate
        }
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { action in
            let textField = alert.textFields![0] as UITextField
            if let text = textField.text,
               text.count > 0 {
                self.globalRate = text
                let userPreference = UserDefaults.standard
                userPreference.setValue(text, forKey: self.globalRateKey)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
