//
//  FullImageViewController.swift
//  Morel_Moments
//
//  Created by Hassam Solano-Morel on 11/24/17.
//  Copyright © 2017 Hassam Solano-Morel. All rights reserved.
//

import UIKit

class FullImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var imageURL:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.imageView.sd_setImage(with: URL(string: self.imageURL), placeholderImage: #imageLiteral(resourceName: "Screen Shot 2017-11-13 at 2.02.59 PM"), options: [.continueInBackground,.progressiveDownload])
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
