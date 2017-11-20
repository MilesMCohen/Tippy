//
//  ViewController.swift
//  Tippy
//
//  Created by Miles Cohen on 11/10/17.
//  Copyright © 2017 Miles Cohen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Init()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Properties
    
    @IBOutlet weak var BeforeTax: UITextField!
    @IBOutlet weak var BeforeTaxStepper: UIStepper!
    @IBOutlet weak var AfterTax: UITextField!
    @IBOutlet weak var AfterTaxStepper: UIStepper!
    @IBOutlet weak var TipAmount: UILabel!
    @IBOutlet weak var GrandTotal: UILabel!
    var BeforeTaxModified:Bool!
    var AfterTaxModified:Bool!
    let TipPercentage:Float! = 0.19
    let TaxPercentage:Float! = 0.10
    
    // Actions
    
    @IBAction func BeforeTaxChanged(_ sender: Any) {
        BeforeTaxModified = true
        if let amountString = BeforeTax.text?.CurrencyInputFormatting() {
            BeforeTax.text = amountString
        }
        
        if !AfterTaxModified {
            let AfterTaxAmount:Float = BeforeTaxDollars() * (1 + TaxPercentage)
            AfterTax.text = AfterTaxAmount.CurrencyString()
        }
        
        UpdateTotals()
    }
    @IBAction func BeforeTaxStepped(_ sender: Any) {
        let BeforeTaxAmount:Float = BeforeTaxDollars() + Float(BeforeTaxStepper.value * 0.01)
        BeforeTaxStepper.value = 0
        
        BeforeTax.text = BeforeTaxAmount.CurrencyString()
        BeforeTaxChanged(self)
    }
    @IBAction func AfterTaxChanged(_ sender: Any) {
        AfterTaxModified = true
        if let amountString = AfterTax.text?.CurrencyInputFormatting() {
            AfterTax.text = amountString
        }
        
        if !BeforeTaxModified {
            let BeforeTaxAmount:Float = AfterTaxDollars() / (1 + TaxPercentage)
            BeforeTax.text = BeforeTaxAmount.CurrencyString()
        }
        
        UpdateTotals()
    }
    @IBAction func AfterTaxStepped(_ sender: Any) {
        let AfterTaxAmount:Float = AfterTaxDollars() + Float(AfterTaxStepper.value * 0.01)
        AfterTaxStepper.value = 0
        
        AfterTax.text = AfterTaxAmount.CurrencyString()
        AfterTaxChanged(self)
    }
    @IBAction func Reset(_ sender: Any) {
        Init()
    }
    
    // Functions
    
    func Init() {
        BeforeTax.text = ""
        AfterTax.text = ""
        BeforeTaxModified = false
        AfterTaxModified = false
        AfterTax.becomeFirstResponder()
        UpdateTotals()
    }
    
    func BeforeTaxDollars() -> Float {
        return Float(DropFirst(myString: BeforeTax.text!)) ?? 0.0
    }
    
    func AfterTaxDollars() -> Float {
        return Float(DropFirst(myString: AfterTax.text!)) ?? 0.0
    }
    
    func UpdateTotals() {
        let TipAmountDollars:Float = BeforeTaxDollars() * TipPercentage
        TipAmount.text = TipAmountDollars.CurrencyString()
        
        let GrandTotalDollars:Float = TipAmountDollars + AfterTaxDollars()
        GrandTotal.text = GrandTotalDollars.CurrencyString()
    }
    
    func DropFirst(myString:String) -> String {
        var modified = myString
        if modified.count > 0 {
            modified.remove(at: myString.startIndex)
        }
        
        return modified
    }
}


// Extensions

extension String {
    
    // formatting text for currency textField
    func CurrencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}

extension Float {
    func CurrencyString() -> String {
        return String(format: "$%0.2f", (self * 100.0).rounded(.toNearestOrAwayFromZero) / 100.0)
    }
}
