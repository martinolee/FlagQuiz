//
//  UpdatePopup.swift
//  FlagQuiz
//
//  Created by 이수한 on 11/06/2019.
//  Copyright © 2019 이수한. All rights reserved.
//

import Foundation
import UIKit

let flagAppId = "1425038789"
let title = NSLocalizedString("Update Available", comment:"")
let message = NSLocalizedString("A new version Application is available.", comment:"")
let okBtnTitle = NSLocalizedString("Update", comment:"")
let cancelBtnTitle = NSLocalizedString("Next Time", comment:"")

private var topViewController: UIViewController? {
    guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
    while let presentedViewController = topViewController.presentedViewController {
        topViewController = presentedViewController
    }
    return topViewController
}

enum UpdateType {
    case normal
    case force
}

class UpdateModule {
    
    static func run(updateType: UpdateType) {
        guard let url = URL(string: "https://itunes.apple.com/us/lookup?id=\(flagAppId)") else { return }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, _, _) in
            guard let d = data else { return }
            do {
                guard let results = try JSONSerialization.jsonObject(with: d, options: .allowFragments) as? NSDictionary else { return }
                guard let resultsArray = results.value(forKey: "results") as? NSArray else { return }
                if resultsArray.count == 0 {
                    return
                }
                guard let storeVersion = (resultsArray[0] as? NSDictionary)?.value(forKey: "version") as? String else {
                    
                    UserDefaults.standard.set(nil, forKey: "storeVersion")
                    UserDefaults.standard.synchronize()
                    return
                }
                
                UserDefaults.standard.set(storeVersion, forKey: "storeVersion")
                UserDefaults.standard.synchronize()
                
                guard let installVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
                guard installVersion.compare(storeVersion) == .orderedAscending else { return }
                showAlert(updateType: updateType)
            } catch {
                print("Serialization error")
            }
        })
        task.resume()
    }
    
    private static func showAlert(updateType: UpdateType) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if updateType == .normal {
            let cancelAction = UIAlertAction(title: cancelBtnTitle, style: .default, handler: nil)
            alert.addAction(cancelAction)
        }
        
        let okAction = UIAlertAction(title: okBtnTitle, style: .default, handler: { Void in
            guard let url = URL(string: "itms-apps://itunes.apple.com/app/id\(flagAppId)") else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
                // Fallback on earlier versions
            }
        })
        alert.addAction(okAction)
        
        topViewController?.present(alert, animated: true, completion: nil)
    }
}


// 출처: https://ithoon.tistory.com/19 [Mobile Developer Share]
