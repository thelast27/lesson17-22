//
//  FolderTableViewCell.swift
//  HW17_eldar
//
//  Created by Eldar Garbuzov on 25.05.22.
//

import UIKit

class FolderTableViewCell: UITableViewCell {
    
    let folderPicture  = UIImageView()
    var folderNameTextLable = UILabel()

    static var key = "FolderTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
          
        folderPicture.image = UIImage(systemName: "folder.fill" )
        folderPicture.frame = CGRect(x: 5, y: 5, width: 35, height: 35)
     
        folderNameTextLable.frame = CGRect(x: 55, y: 5, width: 300, height: 35)
    
        addSubview(folderPicture)
        addSubview(folderNameTextLable)
      
    }

    func selection(isSelected: Bool) {
        self.layer.borderColor = .init(red: 255/255, green: 10/255, blue: 10/255, alpha: 1)
        self.layer.borderWidth = isSelected ? 3 : 0
    }
    
}
