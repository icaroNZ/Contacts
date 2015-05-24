//
//  ViewController.swift
//  Contact
//
//  Created by Icaro Barreira Lavrador on 24/05/15.
//  Copyright (c) 2015 Icaro Barreira Lavrador. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var email:AddressBookHelper?
    
    @IBAction func Contacts(sender: UIButton) {
        email?.pickPerson(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        email = AddressBookHelper()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

