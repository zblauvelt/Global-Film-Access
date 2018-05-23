//
//  addRoleVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 5/21/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

class addRoleVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var roleNameLbl: UITextField!
    @IBOutlet weak var roleTypeLbl: UITextField!
    @IBOutlet weak var shortDescriptionLbl: UITextField!
    @IBOutlet weak var detailDescriptionLbl: UITextView!
    @IBOutlet weak var totalBudgetLbl: UILabel!
    @IBOutlet weak var daysNeededLbl: UITextField!
    @IBOutlet weak var dailyRateLbl: UITextField!
    @IBOutlet weak var ageMinimum: UITextField!
    @IBOutlet weak var ageMaximum: UITextField!
    @IBOutlet weak var heightMinFeet: UITextField!
    @IBOutlet weak var heightMinInches: UITextField!
    @IBOutlet weak var heightMaxFeet: UITextField!
    @IBOutlet weak var heightMaxInches: UITextField!
    @IBOutlet weak var ethnicityLbl: UITextField!
    @IBOutlet weak var bodyTypeLbl: UITextField!
    @IBOutlet weak var eyeColorLbl: UITextField!
    @IBOutlet weak var hairColorLbl: UITextField!
    @IBOutlet weak var hairLengthLbl: UITextField!
    @IBOutlet weak var hairTypeLbl: UITextField!
    
    var projectID = ProjectDetailVC.currentProject
    var update: Bool = true
    var castMemberInfo = [Cast]()
    var roleNameID = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateOrAddRole()
        loadPickerViews()
        hideKeyboard()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateOrAddRole() {
        if self.update {
            self.getCastingPositions()
            self.title = roleNameID
        }
    }
    
    //MARK: Get Casting Info
    func getCastingPositions() {
        Cast.REF_PRE_PRODUCTION_CASTING_POSITION.child(projectID).child(FIRDataCast.cast.rawValue).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.castMemberInfo.removeAll()
                for snap in snapshot {
                    print("SNAP:\(snap)")
                    
                    if let positionDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let position = Cast(roleName: key, roleData: positionDict)
                        if self.roleNameID == position.roleName {
                            self.castMemberInfo.append(position)
                        }
                    }
                }
                self.fillInText()
            }
        })
    }
    
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "" , message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { action in
            return
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    
    @IBAction func saveBtnTapped(_ sender: Any) {
        if let roleName = roleNameLbl.text,
            let roleType = roleTypeLbl.text,
            let shortDescription = shortDescriptionLbl.text,
            let detailDescription = detailDescriptionLbl.text,
            let daysNeeded = daysNeededLbl.text,
            let dailyRate = dailyRateLbl.text,
            let ageMin = ageMinimum.text,
            let ageMax = ageMaximum.text,
            let heightMinFeet = heightMinFeet.text,
            let heightMinInches = heightMinInches.text,
            let heightMaxFeet = heightMaxFeet.text,
            let heightMaxInches = heightMaxInches.text,
            let ethnicity = ethnicityLbl.text,
            let bodyType = bodyTypeLbl.text,
            let eyeColor = eyeColorLbl.text,
            let hairColor = hairColorLbl.text,
            let hairLength = hairLengthLbl.text,
            let hairType = hairTypeLbl.text {
            
            let newRole = Cast(roleName: roleName, roleType: roleType, shortDescription: shortDescription, detailDescription: detailDescription)
            
            do {
                try newRole.createRole(projectID: projectID, role: newRole, daysNeeded: daysNeeded, dailyRate: dailyRate, ageMin: ageMin, ageMax: ageMax, heightMinFeet: heightMinFeet, heightMinInches: heightMinInches, heightMaxFeet: heightMaxFeet, heightMaxInches: heightMaxInches, bodyType: bodyType, eyeColor: eyeColor, hairColor: hairColor, hairLength: hairLength, hairType: hairType, ethnicity: ethnicity, update: update)
                self.update = false
                self.dismiss(animated: true, completion: nil)
            } catch CreateRoleError.invalidRoleName {
                showAlert(message: CreateRoleError.invalidRoleName.rawValue)
            } catch CreateRoleError.invalidRoleType {
                showAlert(message: CreateRoleError.invalidRoleType.rawValue)
            } catch CreateRoleError.invalidShortDescription {
                showAlert(message: CreateRoleError.invalidShortDescription.rawValue)
            } catch CreateRoleError.invalidDetailDescription {
                showAlert(message: CreateRoleError.invalidDetailDescription.rawValue)
            } catch CreateRoleError.invalidMinAge {
                showAlert(message: CreateRoleError.invalidMinAge.rawValue)
            } catch CreateRoleError.invalidMaxAge {
                showAlert(message: CreateRoleError.invalidMaxAge.rawValue)
            } catch CreateRoleError.invalidMinHeight {
                showAlert(message: CreateRoleError.invalidMinHeight.rawValue)
            } catch CreateRoleError.invalidMaxHeight {
                showAlert(message: CreateRoleError.invalidMaxHeight.rawValue)
            } catch CreateRoleError.duplicatePosition {
                showAlert(message: CreateRoleError.duplicatePosition.rawValue)
            } catch let error {
                showAlert(message: "\(error)")
            }
        }
    }
    
    func fillInText() {
        let roleInfo = castMemberInfo[0]
        roleNameLbl.text = roleInfo.roleName
        roleTypeLbl.text = roleInfo.roleType
        shortDescriptionLbl.text = roleInfo.shortDescription
        detailDescriptionLbl.text = roleInfo.detailDescription
        daysNeededLbl.text = roleInfo.daysNeeded
        dailyRateLbl.text = roleInfo.dailyRate
        ageMinimum.text = roleInfo.ageMin
        ageMaximum.text = roleInfo.ageMax
        
        var daysNeededTotal = 0
        if let daysNeeded = roleInfo.daysNeeded {
            
            if let daysNeededInt = Int(daysNeeded) {
                daysNeededTotal = daysNeededInt
            }
        }
        
        var dailyRateTotal = 0
        if let dailyRate = roleInfo.dailyRate {
            if let dailyRateInt = Int(dailyRate) {
                dailyRateTotal = dailyRateInt
            }
        }
        let totalBudget = daysNeededTotal * dailyRateTotal
        let totalBudgetString = totalBudget.formattedWithSeparator
        totalBudgetLbl.text = "$\(totalBudgetString)"
        
        var heightMinFeetTotal = 0
        var heightMinInchesTotal = 0
        if let heightMin = roleInfo.heightMin {
            if let heightMinInt = Int(heightMin) {
                heightMinFeetTotal = (heightMinInt / 12)
                heightMinInchesTotal = heightMinInt - (heightMinFeetTotal * 12)
            }
        }
        heightMinFeet.text = "\(heightMinFeetTotal)"
        heightMinInches.text = "\(heightMinInchesTotal)"
        
        var heightMaxFeetTotal = 0
        var heightMaxInchesTotal = 0
        if let heightMax = roleInfo.heightMax {
            if let heightMaxInt = Int(heightMax) {
                 heightMaxFeetTotal = (heightMaxInt / 12)
                heightMaxInchesTotal = heightMaxInt - (heightMaxFeetTotal * 12)
            }
        }
        heightMaxFeet.text = "\(heightMaxFeetTotal)"
        heightMaxInches.text = "\(heightMaxInchesTotal)"
        
        
        if let ethnicity = roleInfo.ethnicity {
            self.ethnicityLbl.text = ethnicity.rawValue
        } else {
            self.ethnicityLbl.text = ""
        }
        
        if let bodyType = roleInfo.bodyType {
            self.bodyTypeLbl.text = bodyType.rawValue
        } else {
            self.bodyTypeLbl.text = ""
        }
        
        if let eyeColor = roleInfo.eyeColor {
            self.eyeColorLbl.text = eyeColor.rawValue
        } else {
            self.eyeColorLbl.text = ""
        }
        
        if let hairColor = roleInfo.hairColor {
            self.hairColorLbl.text = hairColor.rawValue
        } else {
            self.hairColorLbl.text = ""
        }
        
        if let hairLength = roleInfo.hairLength {
            self.hairLengthLbl.text = hairLength.rawValue
        } else {
            self.hairLengthLbl.text = ""
        }
        
        if let hairType = roleInfo.hairType {
            self.hairTypeLbl.text = hairType.rawValue
        } else {
            self.hairTypeLbl.text = ""
        }
    }
    
    
    //MARK: Body types
    var bodyTypes: [BodyType] = [.thin, .athletic, .overweight, .obese]
    
    //MARK: Eye Color
    var eyeColors: [EyeColor] = [.amber, .blue, .brown, .gray, .green, .hazel]
    
    //MARK: Hair Color
    var hairColors: [HairColor] = [.black, .blonde, .brown, .other]
    
    //MARK: Hair Length
    var hairLengths: [HairLength] = [.short, .medium, .long]
    
    //MARK: Hair Type
    var hairTypes: [HairType] = [.straight, .wavy, .curly]
    
    //MARK: Ethnicity
    var ethnicities: [Ethnicity] = [.americanIndianAlaskanNative, .asian, .blackAfricanAmerican, .hispanicLatino, .nativeHawaiianPacificIslander, .white]
    
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return bodyTypes.count
        case 2:
            return eyeColors.count
        case 3:
            return hairColors.count
        case 4:
            return hairLengths.count
        case 5:
            return hairTypes.count
        case 6:
            return ethnicities.count
        default:
            return 1
            
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return bodyTypes[row].rawValue as String
        case 2:
            return eyeColors[row].rawValue as String
        case 3:
            return hairColors[row].rawValue as String
        case 4:
            return hairLengths[row].rawValue as String
        case 5:
            return hairTypes[row].rawValue as String
        case 6:
            return ethnicities[row].rawValue as String
        default:
            return "Not Available"
            
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            bodyTypeLbl.text = bodyTypes[row].rawValue
        } else if pickerView.tag == 2 {
            eyeColorLbl.text = eyeColors[row].rawValue
        } else if pickerView.tag == 3 {
            hairColorLbl.text = hairColors[row].rawValue
        } else if pickerView.tag == 4 {
            hairLengthLbl.text = hairLengths[row].rawValue
        } else if pickerView.tag == 5 {
            hairTypeLbl.text = hairTypes[row].rawValue
        } else if pickerView.tag == 6 {
            ethnicityLbl.text = ethnicities[row].rawValue
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    //MARK: Picker Views
    ///Load picker views
    func loadPickerViews() {
        
        //Body type
        let bodyTypePickerView = UIPickerView()
        bodyTypePickerView.delegate = self
        bodyTypePickerView.tag = 1
        bodyTypeLbl.inputView = bodyTypePickerView
        
        //Eye Color
        let eyeCOlorPickerView = UIPickerView()
        eyeCOlorPickerView.delegate = self
        eyeCOlorPickerView.tag = 2
        eyeColorLbl.inputView = eyeCOlorPickerView
        
        //Hair Color
        let hairColorPickerView = UIPickerView()
        hairColorPickerView.delegate = self
        hairColorPickerView.tag = 3
        hairColorLbl.inputView = hairColorPickerView
        
        //Hair Length
        let hairLengthPickerView = UIPickerView()
        hairLengthPickerView.delegate = self
        hairLengthPickerView.tag = 4
        hairLengthLbl.inputView = hairLengthPickerView
        
        //Hair Type
        let hairTypePickerView = UIPickerView()
        hairTypePickerView.delegate = self
        hairTypePickerView.tag = 5
        hairTypeLbl.inputView = hairTypePickerView
        
        //Ethnicity
        let ethnicityPickerView = UIPickerView()
        ethnicityPickerView.delegate = self
        ethnicityPickerView.tag = 6
        ethnicityLbl.inputView = ethnicityPickerView
    }
    
    
    
    
}
