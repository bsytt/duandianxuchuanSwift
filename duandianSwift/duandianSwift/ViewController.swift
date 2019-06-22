//
//  ViewController.swift
//  duandianSwift
//
//  Created by 包曙源 on 2019/3/12.
//  Copyright © 2019年 bsy. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
class ViewController: UIViewController {
    var mark:Bool?
    
    lazy var progressLab: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 100, width: view.frame.size.width, height: 20))
        label.text = "zhanwei"
        return label
    }()
    lazy var progress: UIProgressView = {
        let pro = UIProgressView(frame: CGRect(x: 30, y: 150, width: view.frame.width-60, height: 10))
        return pro
    }()
    lazy var bagin: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setTitle("开始", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.frame = CGRect(x: 60, y: 170, width: 80, height: 30)
        button.addTarget(self, action: #selector(selectBagin), for: UIControl.Event.touchDown)
        return button
    }()
    lazy var stop: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setTitle("停止", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.frame = CGRect(x: 150, y: 170, width: 80, height: 30)
        button.addTarget(self, action: #selector(stopBagin), for: UIControl.Event.touchDown)
        return button
    }()
    lazy var cancel: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setTitle("取消", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.frame = CGRect(x: 60, y: 210, width: 80, height: 30)
        button.addTarget(self, action: #selector(cancelBagin), for: UIControl.Event.touchDown)
        return button
    }()
    lazy var duandian: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setTitle("断点下载", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.frame = CGRect(x: 150, y: 210, width: 80, height: 30)
        button.addTarget(self, action: #selector(duandianBagin), for: UIControl.Event.touchDown)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mark = true
        self.view.addSubview(self.progressLab)
        self.view.addSubview(self.progress)

        self.view.addSubview(self.bagin)
        self.view.addSubview(self.stop)
        self.view.addSubview(self.cancel)
        self.view.addSubview(self.duandian)
    }
    @objc func selectBagin() {
        AlaNetworkingManager.shared.downFile("http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
//        AlaNetworkingManager.shared.progressBlock = { (num) in
//            self.progress.progress = num
//            self.progressLab.text = "当前进度:\(num*100)%"
//        }
        AlaNetworkingManager.shared.delegate = self
//        AlaNetworkingManager.shared.callBackFunction { (num) in
//
//        }
//        AlaNetworkingManager.shared.pathBlock = { (path) in
//            print(path)
//
////            let item = AVPlayerItem(url:)
//
//
//        }
    }

    @objc func stopBagin() {
        if mark! {
            self.stop.setTitle("继续", for: UIControl.State.normal)
            AlaNetworkingManager.shared.stop()
        }else {
            self.stop.setTitle("停止", for: UIControl.State.normal)
            AlaNetworkingManager.shared.goon()
        }
        mark = !mark!
    }
    @objc func cancelBagin() {
       AlaNetworkingManager.shared.cancel()
    }
    @objc func duandianBagin() {
        AlaNetworkingManager.shared.duandian()
    }
}
extension ViewController:ProgressBlock {
    func pathBlock(str: String) {
        let url = URL(fileURLWithPath:str)
        let play = AVPlayer(url: url)
        let playController = AVPlayerViewController()
        playController.player = play
        self.present(playController, animated: true, completion: {
            playController.player?.play()
        })
    }
    
    func progressBlock(num: Float) {
        self.progress.progress = num
        self.progressLab.text = "当前进度:\(num*100)%"
    }
    
    
}
