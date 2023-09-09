//
//  NavigationTableViewController.swift
//  AdvancedUIViewShadowEffects
//
//  Created by Artur Remizov on 8.09.23.
//

import UIKit

class NavigationTableViewController: UITableViewController {
    
    let shadows: [ShadowType] = ShadowType.allCases
    
    override func viewDidLoad() {
        title = "Advanced UIView shadow effects"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shadows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = shadows[indexPath.row].rawValue
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ViewController(shadowType: shadows[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}

