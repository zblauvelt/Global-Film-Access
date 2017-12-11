//
//  CreateProjectVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 12/6/17.
//  Copyright © 2017 Zachary Blauvelt. All rights reserved.
//

import UIKit

class CreateProjectVC: UIViewController {
    @IBOutlet weak var containerView: CustomView!
    @IBOutlet weak var projectNameLbl: CommonTextField!
    @IBOutlet weak var dateLbl: CommonTextField!
    let picker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        //Animation for View
        containerView.transform = CGAffineTransform.init(scaleX: 0, y:0)
    }
  //Animation for View
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform.identity
        })
    }
    
    
    
    
    
    
    //Creation of datepicker
    func createDatePicker() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        dateLbl.inputAccessoryView = toolbar
        dateLbl.inputView = picker
        picker.datePickerMode = .date
    }
    @objc func donePressed() {
        //format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: picker.date)
        dateLbl.text = "\(dateString)"
        self.view.endEditing(true)
    }

}
