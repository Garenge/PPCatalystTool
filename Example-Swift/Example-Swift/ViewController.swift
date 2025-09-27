//
//  ViewController.swift
//  Example-Swift
//
//  Created by Garenge on 2025/9/27.
//

import UIKit
import PPCatalystTool

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        PPCatalystHandle
            .shared()
            .saveToUserDirectory(withFilePath: "/Users/garenge/Downloads/data.db") { url, error in

            }
    }

}

