//
//  FullScreenImageViewController.swift
//  HW17_eldar
//
//  Created by Eldar Garbuzov on 27.05.22.
//

import UIKit

class FullScreenImageViewController: UIViewController {
    @IBOutlet weak var fullScreenView: UIImageView!
    
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullScreenView.image = image
        
        fullScreenView.contentMode = .scaleAspectFill
        view.addSubview(fullScreenView)
  
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
