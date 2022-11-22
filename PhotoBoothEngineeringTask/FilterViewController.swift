//
//  FilterViewController.swift
//  PhotoBoothEngineeringTask
//
//  Created by Imran Muhammad on 11/21/22.
//

import Foundation
import UIKit

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var filterManager: FilterManager!
    let filterTableView = UITableView(frame: .zero, style: .plain)
    var delegate: FilterViewControllerDelegate?
    
    convenience init(filterManager: FilterManager) {
        self.init(nibName: nil, bundle: nil)
        
        self.filterManager = filterManager
        
        let donebutton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(self.didTapDoneButton)
        )
        
        self.navigationItem.rightBarButtonItem = donebutton
        
        let clearFiltersbutton = UIBarButtonItem(
            title: "Clear Filters",
            style: .done,
            target: self,
            action: #selector(self.didTapClearFiltersButton)
        )
        
        self.navigationItem.leftBarButtonItem = clearFiltersbutton
        
        self.view.addSubview(filterTableView)
        filterTableView.contentInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        filterTableView.register(FilterTableViewCell.self, forCellReuseIdentifier: "filterCell")
        filterTableView.delegate = self
        filterTableView.dataSource = self
        filterTableView.translatesAutoresizingMaskIntoConstraints = false
        filterTableView.allowsMultipleSelection = true
        setTableViewconstraints()
    }
    
    func setTableViewconstraints() {
        filterTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        filterTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        filterTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        filterTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    @objc func didTapDoneButton() {
        self.dismiss(animated: true, completion: nil)
        delegate?.didTapDoneButton()
    }
    
    @objc func didTapClearFiltersButton() {
        self.filterManager.clearAllFilters()
        if let indexPaths = self.filterTableView.indexPathsForSelectedRows {
            for indexPath in indexPaths {
                self.filterTableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
//MARK: TableView datasource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterManager.allFilters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filter = filterManager.allFilters[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as? FilterTableViewCell {
            cell.prepareForReuse()
            cell.configureWith(filter: filter)
            if filter.isSelected {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
            return cell
        }
        else {
            let cell = FilterTableViewCell()
            cell.configureWith(filter: filter)
            if filter.isSelected {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
            return cell
        }
    }
    
//MARK: CollectionView ddelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FilterTableViewCell {
            cell.didTapCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FilterTableViewCell {
            cell.didTapCell()
        }
    }
}
