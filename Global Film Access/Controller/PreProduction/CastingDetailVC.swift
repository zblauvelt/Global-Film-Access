//
//  CastingDetailVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 2/7/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit

class CastingDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var selectedCastPosition: String = ""
    static var positionName: String = ""
    var selectedRole = [Cast]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        CastingDetailVC.positionName = selectedCastPosition
        self.title = selectedCastPosition
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchTalent" {
            let desVC = segue.destination as! SearchTalentVC
            desVC.searchingRole.append(selectedRole[0])
        }
    }

    @IBAction func unwindToCastingDetail(segue: UIStoryboardSegue) {}

}
