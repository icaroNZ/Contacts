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
    
    var pickerDetail:Bool
    
    init(_ coder: NSCoder? = nil) {
        pickerDetail = false
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
    
    convenience init(displayProperties: [Int])
    {
        self.init()
        self.displayedProperties = displayedProperties
    }
    
    func pickPerson(view: UIViewController){
        view.presentViewController(self, animated: true, completion: nil)
    }
    

}

extension AddressBookHelper: ABPeoplePickerNavigationControllerDelegate{
    
    func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController!) {
        
    }
    
    //implement this --->
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecord!) {
        if !pickerDetail{return}
        if peoplePicker != self{
            return
        }
        let emails: ABMultiValueRef = ABRecordCopyValue(person, kABPersonEmailProperty).takeRetainedValue() as ABMultiValueRef
        let allEmails = ABMultiValueCopyArrayOfAllValues(emails).takeRetainedValue() as NSArray
        for email in allEmails{
            println(email)
        }
    }

    //or this <---
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecord!, property: ABPropertyID, identifier: ABMultiValueIdentifier) {
        let address: ABMultiValueRef = ABRecordCopyValue(person, property).takeRetainedValue()
        let index = Int(identifier) as CFIndex
        let addres = ABMultiValueCopyValueAtIndex(address, index).takeRetainedValue() as! NSDictionary
        println("Country: \(addres)")
    }
}

class getAllAddresses{

    lazy var addressBook: ABAddressBookRef = {
        var error: Unmanaged<CFError>?
        return  ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue() as ABAddressBookRef
    }()
    
    init(){
        switch ABAddressBookGetAuthorizationStatus(){
        case .Authorized:
            println("Authorized")
            readFromAddressBook(addressBook)
        case .Denied:
            println("Denied")
        case .NotDetermined:
            println("Not Determined")
            ABAddressBookRequestAccessWithCompletion(addressBook){
                [weak self]
                (granted, error) -> Void in
                if granted{
                    let strongSelf = self!
                    println("Access granted")
                    self!.readFromAddressBook(strongSelf.addressBook)
                } else {println("Access not granted")}
            }
        case .Restricted:
            println("Restrict")
        default:
            println("Unhandled")
        }
       
    }
    
    func readFromAddressBook(addressBook: ABAddressBookRef){
        let allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray
        for person in allPeople
        {
            println(person)
        }
    }
    
    func imageForPerson(person: ABRecordRef) -> UIImage?{
        let data = ABPersonCopyImageData(person).takeRetainedValue() as NSData
        let image = UIImage(data: data)
        return image
    }

    func newPersonWithFirstName(firstName: String, lastName: String, inAddressBook: ABAddressBookRef) -> ABRecordRef?{
        
        let person: ABRecordRef = ABPersonCreate().takeRetainedValue()
        let couldSetFirstName = ABRecordSetValue(person, kABPersonFirstNameProperty, firstName as CFTypeRef, nil)
        let couldSetLastName = ABRecordSetValue(person, kABPersonLastNameProperty, lastName as CFTypeRef, nil)
        
        var error:Unmanaged<CFErrorRef>? = nil
        let couldAddPerson = ABAddressBookAddRecord(inAddressBook, person, &error)
        if couldAddPerson{
            println("Sucessfully add person")
        } else {println("Faile to add person"); return nil}
        
        if ABAddressBookHasUnsavedChanges(inAddressBook){
            var error: Unmanaged<CFErrorRef>? = nil
            let couldSaveInAddressBook = ABAddressBookSave(inAddressBook, &error)
            
            if couldSaveInAddressBook{
                println("Sucessfully save in AddressBook")
            } else {println("Fail to save in AddressBook")}
        }

        if couldSetFirstName && couldSetLastName{
            println("Sucessfully set first and last name")
        } else {println("Fail to set first and/or last name")}
        
        return person
    }
    
    func setImageForPerson(person: ABRecordRef, inAddressBook addressBook: ABAddressBookRef, imageData: NSData) -> Bool{
        var error:Unmanaged<CFErrorRef>? = nil
        let couldSetPersonImage = ABPersonSetImageData(person, imageData as CFDataRef, &error)
        if couldSetPersonImage{
            println("Successfully set persons image, saving")
            if ABAddressBookHasUnsavedChanges(addressBook){
                error = nil
                let couldSaveAddressBook = ABAddressBookSave(addressBook, &error)
                if couldSaveAddressBook{
                    println("Successfully save AddressBook")
                    return true
                } else{
                    println("Fail to save AddressBook")
                }
            }  else {
                println("There are no changes save")
            }
        } else {
            println("Fail to set person's image")
        }
        return false
    }
    
    func performExample(){
        let person: ABAddressBookRef? = newPersonWithFirstName("Icaro", lastName: "Lavrador", inAddressBook: addressBook)
        if let me:ABRecordRef = person{
            let newImage = UIImage(named: "greyBody1")
            let newImageData = UIImageJPEGRepresentation(newImage, 1)
            if setImageForPerson(me, inAddressBook: addressBook, imageData: newImageData){
                println("Seccessgully set the person image")
                let image = imageForPerson(me)
                if let currentImage = image{
                    println("Found Image")
                } else {
                    println("This person has no Image")
                }
            } else {
                println("Could not set the person's image")
            }
            
        }
    }
    
}