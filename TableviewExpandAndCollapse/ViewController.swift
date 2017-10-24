//
//  ViewController.swift
//  TableviewExpandAndCollapse
//
//  Created by Ammy Pandey on 24/10/17.
//  Copyright © 2017 Ammy Pandey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var shopTable: UITableView!
    
    struct Section {
        var name: String!
        var items: [String]!
        var collapsed: Bool!
        
        init(name: String, items: [String], collapsed: Bool = false) {
            self.name = name
            self.items = items
            self.collapsed = collapsed
        }
    }
    
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Mark: Put Data on sections variable
        
        sections = [
            Section(name: "Mac", items: ["MacBook", "MacBook Air", "MacBook Pro", "iMac", "Mac Pro", "Mac mini", "Accessories", "OS X El Capitan"]),
            Section(name: "iPad", items: ["iPad Pro", "iPad Air 2", "iPad mini 4", "Accessories"]),
            Section(name: "iPhone", items: ["iPhone 6s", "iPhone 6", "iPhone SE", "Accessories"])
        ]
    }
}

//Mark: Extension For TableView

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return tableView.rowHeight
        }
        
        //Calculate the real section index and row index
        let section = getSectionIndex(indexPath.row)
        let row = getRowIndex(indexPath.row)
        
        //Header has fixed height
        if row == 0 {
            return 50.0
        }
        return sections[section].collapsed! ? 0: 44.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Manufatcure"
        case 1: return "Product"
        default: return ""
        }
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        }
        
        /*
             for section 1, the total count is item count plus the number of headers
         */
        var count = sections.count
        for section in sections {
            count += section.items.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "title") as UITableViewCell!
            cell?.textLabel?.text = "Apple"
            return cell!
        }
        //Calculate the real section and index
        let section = getSectionIndex(indexPath.row)
        let row = getRowIndex(indexPath.row)
        
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! HeadersTableViewCell
            cell.titleLbl.text = sections[section].name
            cell.toggleBtn.tag = section
            cell.toggleBtn.setTitle(sections[section].collapsed! ? "+": "-", for: UIControlState())
            cell.toggleBtn.addTarget(self, action: #selector(toggleCollapse(_:)), for: .touchUpInside)
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
            cell?.textLabel?.text = sections[section].items[row - 1]
            return cell!
        }
    }
}



extension ViewController {
    //Mark Event Handler
    
    @objc func toggleCollapse(_ sender: UIButton) {
        let section = sender.tag
        let collapsed = sections[section].collapsed
        
        //Toggle Collapse
        sections[section].collapsed = !collapsed!
        
        let indcies = getHeaderIndcies()
        
        let start = indcies[section]
        let end = start + sections[section].items.count
        
        shopTable.beginUpdates()
        for i in start ..< end + 1 {
            shopTable.reloadRows(at: [IndexPath(row: i, section: 1)], with: .automatic)
        }
        shopTable.endUpdates()
    }
    
    
    
    //Mark Helper Function
    
    func getSectionIndex(_ row: NSInteger) -> Int {
        
        let indcies = getHeaderIndcies()
        
        for i in 0..<indcies.count {
            if i == indcies.count - 1 || row < indcies[i + 1] {
                return i
            }
        }
        return -1
    }
    
    func getRowIndex(_ row: NSInteger) -> Int {
        
        var index = row
        let indices = getHeaderIndcies()
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                index -= indices[i]
                break
            }
        }
        return index
    }
    
    func getHeaderIndcies() -> [Int] {
        
        var index = 0
        var indices: [Int] = []
        
        for section in sections {
            indices.append(index)
            index += section.items.count + 1
        }
        return indices
    }
}










