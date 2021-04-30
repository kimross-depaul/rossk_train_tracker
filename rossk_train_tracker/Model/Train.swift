//
//  Train.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 4/29/21.
//

import Foundation

class Train {
    var line: String;
    var stops: [TrainStop];
    
    init(line: String) {
        self.line = line;
        stops = [TrainStop]();
    }
}
