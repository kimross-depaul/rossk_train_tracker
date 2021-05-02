//
//  Observer.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 5/1/21.
//

protocol Observer {
    var isDataLoaded: Bool {get set}
    func refresh()
}

