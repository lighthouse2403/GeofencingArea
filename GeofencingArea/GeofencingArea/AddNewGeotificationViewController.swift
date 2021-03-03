//
//  AddNewGeotificationViewController.swift
//  GeofencingArea
//
//  Created by Thuy Phan on 3/2/21.
//

import UIKit
import MapKit

protocol AddNewGeotificationViewControllerDelegate: class {
  func addGeotificationViewController(_ controller: AddNewGeotificationViewController, didAddGeotification: GeotificationHandler)
}

class AddNewGeotificationViewController: UITableViewController {
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var zoomButton: UIBarButtonItem!
    @IBOutlet weak var radiusTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var wifiNameTextfield: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    var firstUserCoordinate: CLLocationCoordinate2D?
    weak var delegate: AddNewGeotificationViewControllerDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItems = [addButton, zoomButton]
    addButton.isEnabled = false
    if let firstName = WifiHandler.getSSIDs().first {
        self.wifiNameTextfield.text = firstName
    }
    
    //Zoom to user location with radius: 2000 km
    if let userLocation = self.firstUserCoordinate {
        let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(viewRegion, animated: false)
    }
  }

    
  @IBAction func textFieldEditingChanged(sender: UITextField) {
    let radiusSet = !(radiusTextField.text?.isEmpty ?? true)
    let noteSet = !(noteTextField.text?.isEmpty ?? true)
    addButton.isEnabled = radiusSet && noteSet
  }

  @IBAction func onCancel(sender: AnyObject) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction private func onAdd(sender: AnyObject) {
    let coordinate  = mapView.centerCoordinate
    let radius      = Double(radiusTextField.text ?? "") ?? 0
    let identifier  = NSUUID().uuidString
    let note        = noteTextField.text ?? ""
    let eventType: GeotificationHandler.EventType = .onEntry
    let wifi = self.wifiNameTextfield.text ?? ""
    let geotification = GeotificationHandler(
      coordinate: coordinate,
      radius: radius,
      identifier: identifier,
      note: note,
      eventType: eventType,
      wifiName: wifi
    )
    delegate?.addGeotificationViewController(self, didAddGeotification: geotification)
  }

  @IBAction private func onZoomToCurrentLocation(sender: AnyObject) {
    mapView.zoomToLocation(mapView.userLocation.location)
  }
}
