//
//  ViewController.swift
//  PhotoBoothEngineeringTask
//
//  Created by Imran Muhammad on 11/16/22.
//

import UIKit

protocol FilterViewControllerDelegate {
    func didTapDoneButton()
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, FilterViewControllerDelegate {

    var layout = UICollectionViewFlowLayout()
    var catCollectionView: UICollectionView!
    var allCats: [Cat] = []
    var filterManager = FilterManager(cats: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let filterbutton = UIBarButtonItem(
            title: "Filter",
            style: .done,
            target: self,
            action: #selector(self.didTapFilterButton)
        )
        self.navigationItem.rightBarButtonItem = filterbutton
        
        let screenWidth = self.view.frame.width
        layout.itemSize = CGSize(width: (screenWidth/2) - 20, height: 150)
        catCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.view.addSubview(catCollectionView)
        catCollectionView.contentInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        catCollectionView.register(CatCollectionViewCell.self, forCellWithReuseIdentifier: "catCell")
        catCollectionView.delegate = self
        catCollectionView.dataSource = self
        catCollectionView.translatesAutoresizingMaskIntoConstraints = false
        setCollectionViewconstraints()
        
        ApiClient.shared.getAllCats(skip: 0, limit: 500) { result in
            switch result {
            case .success(let cats):
                self.allCats = cats
                self.filterManager = FilterManager(cats: self.allCats)
                DispatchQueue.main.async {
                    self.catCollectionView.reloadData()
                }
                
            case .failure(let err):
                print(err)
            }
        
        }
    }
    
    func setCollectionViewconstraints() {
        catCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        catCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        catCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        catCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    @objc func didTapFilterButton() {
        let filterViewcontroller = FilterViewController(filterManager: self.filterManager)
        let navController = UINavigationController(rootViewController: filterViewcontroller)
        self.present(navController, animated:true, completion: nil)
        filterViewcontroller.delegate = self
    }

//MARK: CollectionView datasource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if filterManager.filtersApplied {
            return filterManager.filteredCats.count
        }
        return allCats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var catsToShow = self.allCats

        if filterManager.filtersApplied {
            catsToShow = filterManager.filteredCats
        }
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catCell", for: indexPath) as? CatCollectionViewCell {
            cell.prepareForReuse()
            cell.configureWith(cat:catsToShow[indexPath.row])
            return cell
        }
        else {
            let cell = CatCollectionViewCell(frame: CGRect(x: 0, y: 0, width: layout.itemSize.width, height: layout.itemSize.height))
            cell.configureWith(cat: catsToShow[indexPath.row])
            return cell
        }
    }
    
//MARK: CollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = catCollectionView.cellForItem(at: indexPath) as? CatCollectionViewCell {
            guard let cat = cell.cat else {return}
            let viewController = CatDetailViewController(cat: cat)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
//mark: FilterViewControllerDelegate
    func didTapDoneButton() {
        filterManager.didTapDoneButton()
        self.catCollectionView.reloadData()
    }
}



