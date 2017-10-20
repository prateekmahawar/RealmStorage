//
//  ViewController.swift
//  RealmSwift4
//
//  Created by Prateek Mahawar on 20/10/17.
//  Copyright © 2017 Prateek Mahawar. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var pickUpLines : Results<PickUpLine>!
    
    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = RealmService.shared.realm
        pickUpLines = realm.objects(PickUpLine.self)
        
        notificationToken = realm.addNotificationBlock { (notification, realm) in
            self.tableView.reloadData()
        }
        
        RealmService.shared.observeRealmErrors(in: self) { (error) in
            //handle error
            print(error ?? "no error detected")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        notificationToken?.stop()
        RealmService.shared.stopObservingErrors(in: self)
    }
    
    @IBAction func onAddTapped() {
        AlertService.addAlert(in: self) { (line, score, email) in
            
            let newPickUpLine = PickUpLine(line: line, score: score, email: email)
            RealmService.shared.create(newPickUpLine)
        }
    }
    
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickUpLines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PickUpLineCell") as? PickUpLineCell else { return UITableViewCell() }
        
        let pickUpLine = pickUpLines[indexPath.row]
        cell.configure(with: pickUpLine)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        let pickUpLine = pickUpLines[indexPath.row]
        
        AlertService.updateAlert(in: self, pickUpLine: pickUpLine) { (line, score, email) in
            let dict: [String: Any?] = ["line": line,
                                        "score": score,
                                        "email": email]
            
            RealmService.shared.update(pickUpLine, with: dict)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let pickUpLine = pickUpLines[indexPath.row]
        
        RealmService.shared.delete(pickUpLine)
    }
}
