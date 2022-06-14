//
//  ImageTableViewCell.swift
//  HW17_eldar
//
//  Created by Eldar Garbuzov on 28.05.22.
//

import UIKit

class ImageTableViewCell: UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    
        static var key = "ImageTableViewCell"

    func selection(isSelected: Bool) {
        self.layer.borderColor = .init(red: 255/255, green: 10/255, blue: 10/255, alpha: 1)
        self.layer.borderWidth = isSelected ? 3 : 0
    }
    
  
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundColor = isSelected ? .yellow : .white
   
    }
}
