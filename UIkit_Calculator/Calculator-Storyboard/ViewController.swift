//
//  ViewController.swift
//  UIkit_Calculator
//
//  Created by fanqing_m on 2021/5/16.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var displayLabel: UILabel!
    var op = 0
    var num1 = 0
    var num2 = 0
    var flag = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    var onDisplay:String {
        get {
            return self.displayLabel.text!
        }
        
        set {
            self.displayLabel.text! = newValue
        }
    }
    @IBAction func buttonClick(_ sender: UIButton) {
        
        var number = sender.titleLabel!.text!
        //at button click number should appear at the console.
        //print(sender.titleLabel!.text!)
        displayLabel.text! += number
        if(flag)
        {
        num1 = Int(displayLabel.text!) ?? 0
        print("这是第一个数 \(num1)")
        }
        else
        {
            num2 = Int(displayLabel.text!) ?? 0
            print("这是第二个数 \(num2)")
        }
    }
    
    @IBAction func acTouched(_ sender: UIButton) {
        displayLabel.text = ""
        flag = true
    }
    
    @IBAction func divideTouched(_ sender: UIButton) {
        displayLabel.text = ""
        op = 4
        flag = false
    }
    
    @IBAction func addTouched(_ sender: UIButton) {
        displayLabel.text = ""
        op = 1
        flag = false
    }
    
    @IBAction func substractTouched(_ sender: UIButton) {
        displayLabel.text = ""
        op = 2
        flag = false
    }
    
    @IBAction func multiplyTouched(_ sender: UIButton) {
        displayLabel.text = ""
        op = 3
        flag = false
    }
    @IBAction func equalTouched(_ sender: UIButton) {
        if op==4
        {
            displayLabel.text = String(num1/num2)
        }
        else if op==3
        {
            displayLabel.text = String(num1*num2)
        }
        else if op==2
        {
            displayLabel.text = String(num1 - num2)
        }
        else if op==1
        {
            displayLabel.text = String(num1+num2)
        }

    }
}

