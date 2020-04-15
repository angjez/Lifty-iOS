//
//  TableViewCustomisation.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 10/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation
import UIKit

func customiseTableView (tableView: UITableView, themeColor: UIColor) {
    tableView.preservesSuperviewLayoutMargins = false
    tableView.rowHeight = 70
    tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
    tableView.separatorColor = themeColor
    tableView.backgroundColor = UIColor.white
    tableView.frame = CGRect(x: 20, y: (tableView.frame.origin.y), width: (tableView.frame.size.width)-40, height: (tableView.frame.size.height))
    tableView.layoutMargins = UIEdgeInsets.zero
    tableView.separatorInset = UIEdgeInsets.zero
    tableView.showsHorizontalScrollIndicator = false
    tableView.showsVerticalScrollIndicator = false
}

func setLabelRowCellProperties (cell: UITableViewCell, textColor: UIColor, borderColor: UIColor) {
    cell.textLabel!.textColor = textColor
    cell.indentationLevel = 2
    cell.indentationWidth = 10
    cell.backgroundColor = UIColor.white
    cell.layer.borderColor = borderColor.cgColor
    cell.layer.borderWidth = 3.0
    cell.contentView.layoutMargins.right = 20
}
