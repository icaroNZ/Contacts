//
//  AddressBookHelper.swift
//  Contact
//
//  Created by Icaro Barreira Lavrador on 24/05/15.
//  Copyright (c) 2015 Icaro Barreira Lavrador. All rights reserved.
//
import UIKit
import AddressBookUI

class AddressBookHelper: ABPeoplePickerNavigationController {
    
    
    init(_ coder: NSCoder? = nil) {
        if let coder = coder {
            super.init(coder: coder)
        } else {
            super.init(nibName: nil, bundle:nil)
        }
        self.peoplePickerDelegate = self
    }
    
    required convenience init(coder: NSCoder) {
        self.init(coder)
    }
    
    
    func pickPerson(view: UIViewController){
        view.presentViewController(self, animated: true, completion: nil)
    }
    

}

extension AddressBookHelper: ABPeoplePickerNavigationControllerDelegate{
    
    func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController!) {
        
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecord!) {
        if peoplePicker != self{
            return
        }
        let emails: ABMultiValueRef = ABRecordCopyValue(person, kABPersonEmailProperty).takeRetainedValue() as ABMultiValueRef
        let allEmails = ABMultiValueCopyArrayOfAllValues(emails).takeRetainedValue() as NSArray
        for email in allEmails{
            println(email)
        }
    }
}
