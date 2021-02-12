//
//  RefreshButton.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 11.02.21.
//

import UIKit

enum ButtonState {
    case doingNothing
    case downloading
}

class RefreshButton: UIBarButtonItem {
    func changeState(_ state: ButtonState) {
        DispatchQueue.main.async {
            switch state {
            case .doingNothing:
                self.title = "Ready"
            case .downloading:
                self.title = "Downloading..."
            }
        }
    }
}
