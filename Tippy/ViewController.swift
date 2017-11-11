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
    @IBOutlet weak var AfterTax: UITextField!
    @IBOutlet weak var TipAmount: UILabel!
    @IBOutlet weak var GrandTotal: UILabel!
    var BeforeTaxModified:Bool!
    var AfterTaxModified:Bool!
    let TipPercentage:Float! = 0.19
    let TaxPercentage:Float! = 0.10
    
    // Actions
    
    @IBAction func BeforeTaxChanged(_ sender: Any) {
        BeforeTaxModified = true
        if let amountString = BeforeTax.text?.currencyInputFormatting() {
            BeforeTax.text = amountString
        }
        
        if !AfterTaxModified {
            let AfterTaxAmount:Float = BeforeTaxDollars() * (1 + TaxPercentage)
            AfterTax.text = String(format: "$%.02f", AfterTaxAmount)
        }
        
        UpdateLabels()
    }
    @IBAction func AfterTaxChanged(_ sender: Any) {
        AfterTaxModified = true
        if let amountString = AfterTax.text?.currencyInputFormatting() {
            AfterTax.text = amountString
        }
        
        if !BeforeTaxModified {
            let BeforeTaxAmount:Float = AfterTaxDollars() / (1 + TaxPercentage)
            BeforeTax.text = String(format: "$%.02f", BeforeTaxAmount)
        }
        
        UpdateLabels()
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
        UpdateLabels()
    }
    
    func BeforeTaxDollars() -> Float {
        return Float(DropFirst(myString: BeforeTax.text!)) ?? 0.0
    }
    
    func AfterTaxDollars() -> Float {
        return Float(DropFirst(myString: AfterTax.text!)) ?? 0.0
    }
    
    func UpdateLabels() {
        let TipAmountDollars:Float = BeforeTaxDollars() * TipPercentage
        TipAmount.text = String(format: "$%.02f", TipAmountDollars)
        
        let GrandTotalDollars:Float = TipAmountDollars + AfterTaxDollars()
        GrandTotal.text = String(format: "$%0.2f", GrandTotalDollars)
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
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}
