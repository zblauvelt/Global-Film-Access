//
//  CreateProfileVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 1/7/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit

class CreateProfileVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickState: UITextField!
   
    
    let usaStates: [USAState] = [.alabama, .alaska, .arizone, .arkansas, .california, .colorado, .connecticut, .delaware, .florida, .georgia, .hawaii, .idaho, .illinois, .indiana, .iowa, .kansas, .kentucky, .louisiana, .maine, .maryland, .massachusetts, .michigan, .minnesota, .mississippi, .missouri, .montana, .nebraska, .nevada, .newHampshire, .newJersey, .newMexico, .newYork, .northCarolina, .northDakota, .ohio, .oklahoma, .oregon, .pennsylvania, .rhodeIsland, .southCarolina, .southDakota, .tennessee, .texas, .utah, .vermont, .virginia, .washington, .westVirginia, .wisconsin, .wyoming]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(usaStates.count)
        getStatePickers(pickState)
    }

    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return usaStates.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return usaStates[row].rawValue as String
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickState.text = usaStates[row].rawValue
    }
    //MARK:- TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.getStatePickers(pickState)
    }
    
    //UIViewPicker for State
    func getStatePickers(_ textField : UITextField){
        let statePickerView = UIPickerView()
        statePickerView.delegate = self
        textField.inputView = statePickerView
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        
        let cancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(CreateProfileVC.cancelPressed(sender:)))
        
        let done = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(CreateProfileVC.donePressed(sender:)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/3, height: 40))
        
        label.font = UIFont.systemFont(ofSize: 14)
        
        label.textColor = UIColor.yellow
        
        label.text = "Pick a State"
        
        label.textAlignment = NSTextAlignment.center
        
        let textButton = UIBarButtonItem(customView: label)
        
        toolBar.setItems([cancel, flexSpace, textButton, flexSpace, done], animated: true)
        
        pickState.inputAccessoryView = toolBar
    }
    //MARK:- Button
    @objc func donePressed(sender: UIBarButtonItem) {
        
        pickState.resignFirstResponder()
    }
    
    @objc func cancelPressed(sender: UIBarButtonItem) {
        
        //pickState.text = "iPhone 7 Plus Jet Black"
        
        pickState.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
