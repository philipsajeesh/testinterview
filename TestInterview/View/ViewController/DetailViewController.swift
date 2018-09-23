//
//  DetailViewController.swift
//  TestInterview
//
//  Created by Sajeesh Philip on 22/09/18.
//  Copyright © 2018 Sajeesh Philip. All rights reserved.
//

import UIKit


/// View controller to show heroe image
class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var imageUrl:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Set image
        if let url = imageUrl{
            let img = URL(string: url)
            imageView.kf.setImage(with: img)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
