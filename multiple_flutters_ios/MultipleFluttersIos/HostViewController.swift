// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import Flutter
import FlutterPluginRegistrant
import UIKit

/// UIViewController associated with the NativeViewCount storyboard scene.
class HostViewController: UIViewController, DataModelObserver {
    @IBOutlet weak var countView: UILabel!
    
    deinit {
        DataModel.shared.removeObserver(observer: self)
    }
    
    func onCountUpdate(newCount: Int64) {
        self.countView.text = String(format: "%d", newCount)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        DataModel.shared.addObserver(observer: self)
        onCountUpdate(newCount: DataModel.shared.count)
    }
    
    @IBAction func onAddCount() {
        DataModel.shared.count = DataModel.shared.count + 1
    }
    
    @IBAction func onNext() {
        self.onOpenFlutterByEntrypoint(entrypoint: "/screen1")
    }
    
    func onOpenFlutterByEntrypoint(entrypoint: String) {
        let navController = self.navigationController!
        navController.view.backgroundColor = .white
        navController.setNavigationBarHidden(false, animated: true)

        
        let vc = DoubleFlutterViewController()
        navController.pushViewController(vc, animated: true)
    }
}

extension HostViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
