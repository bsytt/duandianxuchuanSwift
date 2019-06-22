//
//  AlaNetworkingManager.swift
//  duandianSwift
//
//  Created by 包曙源 on 2019/3/12.
//  Copyright © 2019年 bsy. All rights reserved.
//

import Foundation
import Alamofire

protocol ProgressBlock :NSObjectProtocol{
    func progressBlock(num:Float)
    func pathBlock(str:String)
}
class AlaNetworkingManager: NSObject {
    
    var downloadRequest:DownloadRequest?
    
     weak var delegate:ProgressBlock?
    var cancelledData:Data? //停止下载时保存已下载部分
 
    static let shared:AlaNetworkingManager = {
        let instance = AlaNetworkingManager()
        return instance
    }()
    let destination:DownloadRequest.DownloadFileDestination = { _, response in
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentURL.appendingPathComponent(response.suggestedFilename!)
        return (fileURL,[.removePreviousFile,.createIntermediateDirectories])
    }

    func downFile(_ urlStr:String)  {
        let url = URL(string: urlStr)
        var requst = URLRequest(url: url!)

        requst.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requst.setValue("23134543223", forHTTPHeaderField: "session_ID")
        
        self.downloadRequest = Alamofire.download(requst, to: self.destination).responseData(completionHandler: { (responseData) in
            switch responseData.result {
            case .success( _):
                //下载完成
                DispatchQueue.main.async {
                    let path = responseData.destinationURL?.path
                    self.delegate?.pathBlock(str: path!)
                }
            case .failure(error:):
                self.cancelledData = responseData.resumeData//意外中止的话把已下载的数据存起来
                let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = documentURL.appendingPathComponent("aaa.tmp", isDirectory: false)
                do {
                   try self.cancelledData?.write(to: fileURL)
                }catch {
//
                }
                break
            }

            
        })
        self.downloadRequest?.downloadProgress(closure: downloadProgress)
    }
    func downloadProgress(progress:Progress){
       delegate?.progressBlock(num: Float(progress.fractionCompleted))
//        progressBlock!(Float(progress.fractionCompleted))
    }
//    func callBackFunction ( block: @escaping (_ num: Float) -> Void ) {
//
//        progressBlock = block
//
//    }
    func stop()  {
        self.downloadRequest?.suspend()
    }
    func goon()  {
        self.downloadRequest?.resume()
    }
    func cancel() {
        self.downloadRequest?.cancel()
    }
    func duandian()  {
        if self.cancelledData == nil {
            let file = FileManager.default
            let documentURL = file.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentURL.appendingPathComponent("aaa.tmp", isDirectory: false)
            self.cancelledData = file.contents(atPath: fileURL.path)
           
        }
        
        self.downloadRequest = Alamofire.download(resumingWith: self.cancelledData!, to: self.destination).responseData { (responseData) in
            switch responseData.result {
            case .success( _):
                //下载完成
                DispatchQueue.main.async {
                    let path = responseData.destinationURL?.path
                    
                    self.delegate?.pathBlock(str: path!)

                }
            case .failure(error:):
                self.cancelledData = responseData.resumeData //意外中止的话把已下载的数据存起来
                break
            }
        }
        self.downloadRequest?.downloadProgress(closure: downloadProgress)
//        let conf = URLSessionConfiguration.background(withIdentifier: "com.deda.cbb")
//        conf.httpMaximumConnectionsPerHost = 8
//        Alamofire.SessionManager.
        
        
    }

}
