//
//  RegistrationTableViewController.swift
//  Hotel Manzana
//
//  Created by Denis Bystruev on 01/03/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class RegistrationTableViewController: UITableViewController {
    
    // MARK: - ... @IBOutlet
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkOutDatePicker: UIDatePicker!
    @IBOutlet weak var numberOfAdultsLabel: UILabel!
    @IBOutlet weak var numberOfAdultsStepper: UIStepper!
    @IBOutlet weak var numberOfChildrenLabel: UILabel!
    @IBOutlet weak var numberOfChildrenStepper: UIStepper!
    @IBOutlet weak var wifiSwitch: UISwitch!
    @IBOutlet weak var roomTypeLabel: UILabel!
    
    // MARK: - ... Properties
    let checkInLabelIndexPath = IndexPath(row: 0, section: 1)
    let checkInPickerIndexPath = IndexPath(row: 1, section: 1)
    let checkOutLabelIndexPath = IndexPath(row: 2, section: 1)
    let checkOutPickerIndexPath = IndexPath(row: 3, section: 1)
    
    var isCheckInPickerShown: Bool = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInPickerShown
        }
    }
    
    var isCheckOutPickerShown: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutPickerShown
        }
    }
    
    var roomType: RoomType? {
        didSet {
            roomTypeLabel.text = roomType?.name
        }
    }
    
    // MARK: - ... UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkInDatePicker.date = midnightToday
        
        updateDateViews()
        updateNumberOfGuests()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let roomType = roomType else { return }
        guard segue.identifier == "RoomSelectionSegue" else { return }
        
        let controller = segue.destination as! RoomSelectionTableViewController
        controller.selectedRoomType = roomType
    }
    
    // MARK: - ... Methods
    func updateDateViews() {
        checkOutDatePicker.minimumDate = checkInDatePicker.date.addingTimeInterval(60 * 60 * 24)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
    }
    
    func updateNumberOfGuests() {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    // MARK: - ... @IBAction
    @IBAction func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let emailAddress = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let wifi = wifiSwitch.isOn
        guard let roomType = roomType else { return }
        
        let registration = Registration(
            firstName: firstName,
            lastName: lastName,
            emailAddress: emailAddress,
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            numberOfAdults: numberOfAdults,
            numberOfChildren: numberOfChildren,
            wifi: wifi,
            roomType: roomType
        )
        
        print(#function, registration)
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        guard segue.identifier == "SaveRoomSegue" else { return }
        
        let controller = segue.source as! RoomSelectionTableViewController
        roomType = controller.selectedRoomType
    }
}

// MARK: - ... UITableViewDelegate
extension RegistrationTableViewController/*: UITableViewDelegate*/ {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath {
        case checkInLabelIndexPath:
            isCheckInPickerShown.toggle()
        case checkOutLabelIndexPath:
            isCheckOutPickerShown.toggle()
        default:
            return
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkInPickerIndexPath:
            return isCheckInPickerShown ? 216 : 0
        case checkOutPickerIndexPath:
            return isCheckOutPickerShown ? 216 : 0
        default:
            return 44
        }
    }
    
}
