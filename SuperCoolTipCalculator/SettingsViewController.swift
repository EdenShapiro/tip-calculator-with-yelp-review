//
//  SettingsViewController.swift
//  SuperCoolTipCalculator
//
//  Created by Eden on 2/3/17.
//  Copyright © 2017 Eden Shapiro. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var picker1: UIPickerView!
    @IBOutlet weak var picker2: UIPickerView!
    @IBOutlet weak var picker3: UIPickerView!
    
    var pickerData = [Int]()
    let defaults = UserDefaults.standard
    var tipPercentages: [Double]!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        tipPercentages = defaults.object(forKey: "tipPercentages") as! [Double]
        
        pickerData += 1...100
        picker1.dataSource = self
        picker1.delegate = self
        picker1.tag = 1
        picker2.dataSource = self
        picker2.delegate = self
        picker2.tag = 2
        picker3.dataSource = self
        picker3.delegate = self
        picker3.tag = 3
//        print(tipPercentages[0])
//        print(tipPercentages[0]*100)
//        print(Int(tipPercentages[0]*100))
        picker1.selectRow(Int(tipPercentages[0]*100)-1, inComponent: 0, animated: true)
        picker2.selectRow(Int(tipPercentages[1]*100)-1, inComponent: 0, animated: true)
        picker3.selectRow(Int(tipPercentages[2]*100)-1, inComponent: 0, animated: true)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: String(pickerData[row]), attributes: [NSForegroundColorAttributeName : UIColor.lightGray])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        print(pickerData[row])
//        print(pickerData[row]/100)
        tipPercentages[pickerView.tag - 1] = Double(pickerData[row])/100.0
        defaults.set(tipPercentages, forKey: "tipPercentages")
        defaults.synchronize()
    }
}
