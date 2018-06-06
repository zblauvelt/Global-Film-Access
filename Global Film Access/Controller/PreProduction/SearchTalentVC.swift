//
//  SearchTalentVC.swift
//  Global Film Access
//
//  Created by Zachary Blauvelt on 2/7/18.
//  Copyright © 2018 Zachary Blauvelt. All rights reserved.
//

import UIKit
import Firebase

class SearchTalentVC: UITableViewController, SearchCellDelegate {

    var searchingRole = [Cast]()
    var unfilteredTalent = [UserType]()
    var filteredTalent = [UserType]()
    var selectedTalent = [UserType]()
    var matchingTalentUserKeys = [String]()
    var isFiltered = false
    static var userProfileImageCache: NSCache<NSString, UIImage> = NSCache()
    let searchController = UISearchController(searchResultsController: nil)
    
    //@IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Talent"
        searchController.searchBar.barStyle = .black
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = ["All", "Role Specific"]
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.delegate = self
        getTalentProfiles()
        
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredTalent = unfilteredTalent.filter({ (talent : UserType) -> Bool in
            let doesTalentMatch = (scope == "All") || doesUserKeyMatch(talent: talent.userKey)
            
            if searchBarIsEmpty() {
                return doesTalentMatch
            } else {
                let fullName = "\(talent.firstName) \(talent.lastName)"
                return doesTalentMatch && fullName.lowercased().contains(searchText.lowercased())
            }
        })
        tableView.reloadData()
    }
    
    func doesUserKeyMatch(talent: String) -> Bool {
        self.filterRoleFeature()
        
        return matchingTalentUserKeys.contains(talent)
    }
    
    func isSearching() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if isSearching() {
            return filteredTalent.count
        } else {
            return unfilteredTalent.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let talent: UserType
        if isSearching() {
            talent = self.filteredTalent[indexPath.row]
        } else {
            talent = self.unfilteredTalent[indexPath.row]
        }
        
        let cellIdentifier = "userSearchCell"
        
        // Configure the cell...
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchTalentCell {
            if let imageURL = talent.profileImage {
                if let img = SearchTalentVC.userProfileImageCache.object(forKey: imageURL as NSString) {
                    cell.configureCell(user: talent, img: img)
                    cell.delegate = self
                    
                } else {
                    cell.configureCell(user: talent)
                    cell.delegate = self

                }
                return cell
            } else {
                cell.configureCell(user: talent)
                cell.delegate = self
                return SearchTalentCell()
                
            }
        } else {
            return SearchTalentCell()
        }
    }
    

    
    
    //MARK: Filter through role needs
    func filterRoleFeature() {
        
            //Filters are in order of how they are checked. Every talent that matches age will then be checked by height and so on.
            var ageFilter = [UserType]()
            var heightFilter = [UserType]()
            var ethnicityFilter = [UserType]()
            var bodyTypeFilter = [UserType]()
            var eyeColorFilter = [UserType]()
            var hairColorFilter = [UserType]()
            var hairLengthFilter = [UserType]()
            print("Filtering....")
            let role = searchingRole[0]
            //MARK: Filtering out age limit
            let roleAgeMin = convertStringToInt(string: role.ageMin)
            let roleAgeMax = convertStringToInt(string: role.ageMax)
            //MARK: If only a minimum age requirement
            if roleAgeMin > 0 && roleAgeMax <= 0 {
                for talent in unfilteredTalent {
                    let talentAge = convertStringToInt(string: talent.age)
                    if talentAge >= roleAgeMin {
                        ageFilter.append(talent)
                    }
                }
            } else if roleAgeMin <= 0 && roleAgeMax > 0 {
                for talent in unfilteredTalent {
                    let talentAge = convertStringToInt(string: talent.age)
                    if talentAge <= roleAgeMax {
                        ageFilter.append(talent)
                    }
                }
            } else if roleAgeMin > 0 && roleAgeMax > 0 {
                for talent in unfilteredTalent {
                    let talentAge = convertStringToInt(string: talent.age)
                    if talentAge >= roleAgeMin && talentAge <= roleAgeMax {
                        ageFilter.append(talent)
                    }
                }
            }  else {
                for talent in unfilteredTalent {
                    ageFilter.append(talent)
                }
            }
            
            //MARK: Filtering out height requirement from age filter
            let roleHeightMin = convertStringToInt(string: role.heightMin)
            let roleHeightMax = convertStringToInt(string: role.heightMax)
            
            if roleHeightMin > 0 && roleAgeMax <= 0 {
                for talent in ageFilter {
                    let talentHeight = convertStringToInt(string: talent.height)
                    if talentHeight >= roleHeightMin {
                        heightFilter.append(talent)
                    }
                }
            } else if roleHeightMin <= 0 && roleHeightMax > 0 {
                for talent in ageFilter {
                    let talentHeight = convertStringToInt(string: talent.height)
                    if talentHeight <= roleHeightMax {
                        heightFilter.append(talent)
                    }
                }
            } else if roleHeightMin > 0 && roleHeightMax > 0 {
                for talent in ageFilter {
                    let talentHeight = convertStringToInt(string: talent.height)
                    if talentHeight >= roleHeightMin && talentHeight <= roleHeightMax {
                        heightFilter.append(talent)
                    }
                }
            } else {
                for talent in ageFilter {
                    heightFilter.append(talent)
                }
            }
            //MARK: Filtering out ethnicity requirements
            let roleEthnicity = role.ethnicity?.rawValue
            
            if roleEthnicity == "" || roleEthnicity == nil {
                for talent in heightFilter {
                    ethnicityFilter.append(talent)
                }
            } else {
                for talent in heightFilter {
                    if roleEthnicity == talent.ethnicity?.rawValue {
                        ethnicityFilter.append(talent)
                    }
                }
            }
            
            //MARK: Filtering out body type requirements
            let roleBodyType = role.bodyType?.rawValue
            if roleBodyType == "" || roleBodyType == nil {
                for talent in ethnicityFilter {
                    bodyTypeFilter.append(talent)
                }
            } else {
                for talent in ethnicityFilter {
                    if roleBodyType == talent.bodyType?.rawValue {
                        bodyTypeFilter.append(talent)
                    }
                }
            }
            
            //MARK: Filtering out eye color requirements
            let roleEyeColor = role.eyeColor?.rawValue
            if roleEyeColor == "" || roleEyeColor == nil {
                for talent in bodyTypeFilter {
                    eyeColorFilter.append(talent)
                }
            } else {
                for talent in bodyTypeFilter {
                    if roleEyeColor == talent.eyeColor?.rawValue {
                        eyeColorFilter.append(talent)
                    }
                }
            }
            
            //MARK: Filtering out hair color requirements
            let roleHairColor = role.hairColor?.rawValue
            if roleHairColor == "" || roleHairColor == nil {
                for talent in eyeColorFilter {
                    hairColorFilter.append(talent)
                }
            } else {
                for talent in eyeColorFilter {
                    if roleHairColor == talent.hairColor?.rawValue {
                        hairColorFilter.append(talent)
                    }
                }
            }
            
            //MARK: Filtering out hair length requirements
            let roleHairLength = role.hairLength?.rawValue
            if roleHairLength == "" || roleHairLength == nil {
                for talent in hairColorFilter {
                    hairLengthFilter.append(talent)
                }
            } else {
                for talent in hairColorFilter {
                    if roleHairLength == talent.hairLength?.rawValue {
                        hairLengthFilter.append(talent)
                    }
                }
            }
            
            //MARK: Filtering out hair type requirements - last filter - goes to roleTalentFilter [UserType]
            let roleHairType = role.hairType?.rawValue
            if roleHairType == "" || roleHairType == nil {
                for talent in hairLengthFilter {
                    self.filteredTalent.append(talent)
                    self.matchingTalentUserKeys.append(talent.userKey)
                }
            } else {
                for talent in hairLengthFilter {
                    if roleHairType == talent.hairType?.rawValue {
                        self.filteredTalent.append(talent)
                        self.matchingTalentUserKeys.append(talent.userKey)
                    }
                }
            }

            self.tableView.reloadData()
    }
    
    //Convert optional string to int
    func convertStringToInt(string: String?) -> Int {
        var int = 0
        if let str = string {
            if let stringToInt = Int(str) {
                int = stringToInt
            }
        }
        return int
    }

    //Get all users for Search
    func getTalentProfiles() {
        UserType.REF_USERS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.unfilteredTalent.removeAll()
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    //If the id matches the id from projects then it will be added to userProjectsDetails Array
                    if let userDetailsDict = snap.value as? Dictionary<String, String> {
                        let key = snap.key
                        let userDetails = UserType(userKey: key, userData: userDetailsDict)
                        self.unfilteredTalent.append(userDetails)
                        if userDetails.searchSelected == SearchSelected.yes {
                            self.selectedTalent.append(userDetails)
                        }
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchToProfile" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! ProfileVC
                if isSearching() {
                    destinationController.currentUserKey = filteredTalent[indexPath.row].userKey
                } else {
                    destinationController.currentUserKey = unfilteredTalent[indexPath.row].userKey
                }
            }
        }
    }
    
    func didTapRadioButton(userKey: String, searchSelected: String) {
        
        if searchSelected == SearchSelected.yes.rawValue {
            let searchSelected = [FIRUserData.searchSelected.rawValue: SearchSelected.no.rawValue]
            UserType.REF_USERS.child(userKey).updateChildValues(searchSelected)
        } else if searchSelected == SearchSelected.no.rawValue {
            let searchSelected = [FIRUserData.searchSelected.rawValue: SearchSelected.yes.rawValue]
            UserType.REF_USERS.child(userKey).updateChildValues(searchSelected)
        } else {
            let searchSelected = [FIRUserData.searchSelected.rawValue: SearchSelected.yes.rawValue]
            UserType.REF_USERS.child(userKey).updateChildValues(searchSelected)
        }
    }
}




extension SearchTalentVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    
    
}


extension SearchTalentVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}










