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
        
        BeforeTax.text = "0"
        AfterTax.text = "0"
        TipAmount.text = "0"
        GrandTotal.text = "0"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Properties
    
    @IBOutlet weak var BeforeTax: UITextField!
    @IBOutlet weak var AfterTax: UITextField!
    @IBOutlet weak var TipAmount: UILabel!
    @IBOutlet weak var GrandTotal: UILabel!
    
}

