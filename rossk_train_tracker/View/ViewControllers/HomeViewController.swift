//
//  HomeViewController.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 4/28/21.
//

import UIKit



class HomeViewController: UIViewController {

    @IBOutlet var btnRed: UIButton!
    @IBOutlet var btnOrange: UIButton!
    @IBOutlet var btnGreen: UIButton!
    @IBOutlet var btnYellow: UIButton!
    @IBOutlet var btnBlue: UIButton!
    @IBOutlet var btnBrown: UIButton!
    @IBOutlet var btnPurple: UIButton!
    @IBOutlet var btnPink: UIButton!
    @IBOutlet var lblMessages: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnRed.styleMe();
        btnOrange.styleMe();
        btnGreen.styleMe();
        btnYellow.styleMe();
        btnBlue.styleMe();
        btnBrown.styleMe();
        btnPurple.styleMe();
        btnPink.styleMe();
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true);
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        line = segue.identifier ?? "";
    }

}
extension UIButton {

    func styleMe(padding: CGFloat = 0.0) {
        self.setTitleColor(UIColor.black, for: UIControl.State.normal);
        let imageSize = self.imageView!.image!.size; //self.imageView!.frame.size
        let titleSize = self.titleLabel!.frame.size
   /*     let test = self.bounds.height;
        let test2 = self.frame.height;
        let test3 = self.imageView!.frame.width;
        let rect = self.imageView!.frame;
        let rect2 = self.imageView!.bounds;*/
        let totalHeight = imageSize.height + titleSize.height + padding + 20.0
        
        self.layer.cornerRadius = 15.0;

        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: 0,
            bottom: -40,
            right: -titleSize.width
        )
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom: -(totalHeight - titleSize.height),
            right: 0
        )
    }

}
