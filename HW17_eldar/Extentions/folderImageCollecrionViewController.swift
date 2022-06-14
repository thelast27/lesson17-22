//
//  folderImageCollecrionViewController.swift
//  HW17_eldar
//
//  Created by Eldar Garbuzov on 7.06.22.
//

import Foundation
import UIKit

extension ViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dictionary.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let key = ContentType(rawValue: section),
              let values = dictionary[key] else { return 0 }
        return values.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        guard let key = ContentType(rawValue: indexPath.section),
              let values = dictionary[key] else { return UICollectionViewCell() }
        
        switch key {
        case .folder:
            guard let folderCell = folderImageCollectionView.dequeueReusableCell(withReuseIdentifier: "folderCollectionViewCell", for: indexPath) as? folderCollectionViewCell else { return UICollectionViewCell() }
            folderCell.selection(isSelected: indeces.contains { $0 == indexPath })
            folderCell.textLableForCollectionViewElement.text = values[indexPath.row].lastPathComponent
            folderCell.isSelected = true
            return folderCell
        default:
            guard let imageCell = folderImageCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as? imageCollectionViewCell else { return UICollectionViewCell() }
            imageCell.selection(isSelected: indeces.contains { $0 == indexPath })
            imageCell.imageViewForCollectionViewElement.image = UIImage(contentsOfFile: values[indexPath.row].path)
            imageCell.isSelected = true
            return imageCell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch stateType {
        case .create:
            vcSelection(indexPath: indexPath)
            cellSelectionCollectionView(indexPath: indexPath, isSelected: true)
        case .selection where indeces.contains(where: { $0 == indexPath }):
            cellSelectionCollectionView(indexPath: indexPath, isSelected: false)
            guard let item = indeces.firstIndex(of: indexPath) else { return }
            indeces.remove(at: item)
//            deleteButton.isEnabled = indeces.count > 0
        case .selection:
            cellSelectionCollectionView(indexPath: indexPath, isSelected: true)
            indeces.append(indexPath)
//            deleteButton.isEnabled = indeces.count > 0
        }
        print("select \(indeces)")
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}
