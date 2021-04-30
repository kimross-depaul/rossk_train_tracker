//
//  HomeViewController.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 4/28/21.
//

import UIKit

var work = [String:Any]();

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
        
        let connect = Connect();
        
        connect.loadData(urlString: "https://lapi.transitchicago.com/api/1.0/ttpositions.aspx?key=3a2367a9d5ca4cd695e310b7350b2b91&rt=Brn&outputType=JSON");
        
       /* let locations = Connect.requestList(urlString: "https://lapi.transitchicago.com/api/1.0/ttpositions.aspx?key=3a2367a9d5ca4cd695e310b7350b2b91&rt=Brn&outputType=JSON", displayLabel: lblMessages );*/
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
        let totalHeight = imageSize.height + titleSize.height + padding
        
        self.layer.cornerRadius = 15.0;

        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: 0,
            bottom: 0,
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