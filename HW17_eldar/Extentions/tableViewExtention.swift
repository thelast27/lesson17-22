//
//  tableViewExtention.swift
//  HW17_eldar
//
//  Created by Eldar Garbuzov on 1.06.22.
//

import Foundation
import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - кол-во cекций
    func numberOfSections(in tableView: UITableView) -> Int {
        return dictionary.keys.count
    }
    
    //MARK: - кол-во строк в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let key = ContentType(rawValue: section),
              let values = dictionary[key] else { return 0 }
        return values.count
    }
    
    func vcSelection(indexPath: IndexPath) {
        guard let key = ContentType(rawValue: indexPath.section),
              let values = dictionary[key] else { return }
        
        switch key {
        case .image:
            guard let controller = storyboard?.instantiateViewController(withIdentifier: "FullScreenImageViewController") as? FullScreenImageViewController else { return }
            controller.image = UIImage(contentsOfFile: values[indexPath.row].path)!
            present(controller, animated: true, completion: nil)
        case .folder:
            guard let controller = storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else { return }
            controller.documentsURL = documentsURL.appendingPathComponent(values[indexPath.row].lastPathComponent)
            controller.title = values[indexPath.row].lastPathComponent
            controller.activeSegmentedControlIndex = segmentedControl.selectedSegmentIndex
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    //MARK: - контент ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let imageCell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as? ImageTableViewCell else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FolderTableViewCell") as? FolderTableViewCell else { return UITableViewCell() }
        
        guard let key = ContentType(rawValue: indexPath.section),
              let values = dictionary[key] else { return UITableViewCell() }
        
        switch key {
        case .folder:
            cell.selection(isSelected: indeces.contains { $0 == indexPath })
            cell.folderNameTextLable.text = values[indexPath.row].lastPathComponent
            cell.isSelected = true
            return cell
        case .image:
            imageCell.selection(isSelected: indeces.contains { $0 == indexPath })
            imageCell.thumbImageView.image = UIImage(contentsOfFile: values[indexPath.row].path)
            imageCell.isSelected = true
            return imageCell
        }
    }
    
    
    //MARK: - селектор для переходов в новый VC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let key = ContentType(rawValue: indexPath.section),
              let values = dictionary[key] else { return }
        
        if key == .folder {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = (storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController)
            VC?.documentsURL = documentsURL.appendingPathComponent(values[indexPath.row].lastPathComponent)
            VC?.title = documentsURL.lastPathComponent
            VC?.activeSegmentedControlIndex = segmentedControl.selectedSegmentIndex
            tableView.reloadData()
            
            navigationController?.pushViewController(VC!, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = (storyboard.instantiateViewController(withIdentifier: "FullScreenImageViewController") as? FullScreenImageViewController)!
            VC.image = UIImage(contentsOfFile: rootDerectory[indexPath.row].path) ?? UIImage()
            present(VC, animated: true)
        }
        
        
    }
    //MARK: - заголовок секций
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { //задаем тайтл для секции
        guard let key = ContentType(rawValue: section),
              let values = dictionary[key],
              !values.isEmpty else { return "" }
        
        switch key {
        case .folder:
            return "Folder"
        case .image:
            return "Image"
        }
    }
    
    
    
} // конец extention

