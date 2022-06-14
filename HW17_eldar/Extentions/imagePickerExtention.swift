//
//  imagePickerExtention.swift
//  HW17_eldar
//
//  Created by Eldar Garbuzov on 1.06.22.
//

import Foundation
import UIKit


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel")
        dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info[.imageURL]!)
        if let imageURL = info[.imageURL] as? URL,
           let editedImage = info[.editedImage] as? UIImage {
            let newImageURL = documentsURL.appendingPathComponent(imageURL .lastPathComponent) //тут добавляем компонент с именем каждый раз разным (по UUID)
            let imageJpgData = editedImage.jpegData(compressionQuality: 1)
            var imageContent = self.dictionary[.image]
            do {
                try imageJpgData?.write(to: newImageURL)
                imageContent?.append(newImageURL)
                dictionary[.image] = imageContent
                rootDerectory.append(newImageURL)
                folderTableView.reloadData()
                folderImageCollectionView.reloadData()
            } catch {
                print(error)
            }
            dismiss(animated: true)
        }
    }
}
