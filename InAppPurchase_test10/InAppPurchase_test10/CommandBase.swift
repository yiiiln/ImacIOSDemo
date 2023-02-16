//
//  CommandBase.swift
//  InAppPurchase_test10
//
//  Created by 侯懿玲 on 2023/2/9.
//

import UIKit

class CommandBase: NSObject {
    
    static let sharedInstance = CommandBase()

    // MARK: - DateFormatter
    
    /// DateFormatter 將時間戳轉換成需要的時間格式
    /// - Parameters:
    ///   - timestamp: 時間戳
    ///   - needFormat: 需要轉換出來的時間格式
    /// - Returns: 轉換完成的時間格式字串
    func dateformatter(timestamp: Int64, needFormat: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        
        let formatter = DateFormatter()
        formatter.dateFormat = needFormat
        let str = formatter.string(from: date)
        
        return str
    }
    
    // MARK: - UIApplication Open URL
    
    /// 開啟指定的 URL
    /// - Parameters:
    ///   - url: URL 字串
    func openURL(with url: String) {
        guard let url = URL(string: url) else {
            return
        }
        guard UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url) { _ in }
    }
    
    // MARK: - UIActivityIndicatorView HUD
    
    /// 顯示 UIActivityIndicatorView 在畫面上
    ///  - Parameters:
    ///    - uiView: 要顯示在哪個畫面上
    func showActivityIndicatorView(uiView: UIView) {
        // 背景
        let container: UIView = UIView()
        container.tag = 100
        container.frame = UIScreen.main.bounds
        container.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        container.backgroundColor = UIColor.fromHex(rgbValue: 0xffffff, alpha: 0.9)
        
        // loading 的背景
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        loadingView.backgroundColor = UIColor.fromHex(rgbValue: 0x444444, alpha: 0.5)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        // loading 圖案
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicatorView.style = .large
        activityIndicatorView.center = CGPoint(x: loadingView.frame.size.width / 2,
                                               y: loadingView.frame.size.height / 2)
        
        loadingView.addSubview(activityIndicatorView)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        
        activityIndicatorView.startAnimating()
    }
    
    /// 從畫面上移除 UIActivityIndicatorView
    ///  - Parameters:
    ///    - uiView: 要從哪個畫面上移除
    func removeActivityIndicatorView(uiView: UIView) {
        if let viewWithTag = uiView.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
    }
}

extension UIColor {
    
    /// 將 Hex 的顏色表達，轉成 RGB 的 UIColor
    /// - Parameters:
    ///   - rgbValue: Hex 的顏色表達
    ///   - alpha: 透明度，預設為 1.0
    /// - Returns: 轉成 RGB 的 UIColor
    static func fromHex(rgbValue: UInt32, alpha: Double = 1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8) / 256.0
        let blue = CGFloat(rgbValue & 0xFF) / 256.0
        return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
    /// navigationBar 的顏色，色碼：#036EB8
    static let navigationBar = UIColor.fromHex(rgbValue: 0x036EB8)
}
