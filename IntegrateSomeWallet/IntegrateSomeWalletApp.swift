//
//  IntegrateSomeWalletApp.swift
//  IntegrateSomeWallet
//
//  Created by javi www on 10/10/22.
//

import SwiftUI
import CoinbaseWalletSDK

@main
struct IntegrateSomeWalletApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    //Test with
                    //xcrun simctl openurl booted "javiwallet://someCallback"
                   print("Opening url ", url)
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Did finish launching")
        CoinbaseWalletSDK.configure(
//            host: URL(string: "samplewallet://wsegue")!,
            callback: URL(string: "javiwallet://mycallback")!
        )
        return true
    }
}

extension UIApplication {
    static func swizzleOpenURL() {
        guard
            let original = class_getInstanceMethod(UIApplication.self, #selector(open(_:options:completionHandler:))),
            let swizzled = class_getInstanceMethod(UIApplication.self, #selector(swizzledOpen(_:options:completionHandler:)))
        else { return }
        method_exchangeImplementations(original, swizzled)
    }
    
    @objc func swizzledOpen(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any], completionHandler completion: ((Bool) -> Void)?) {
        logWalletSegueMessage(url: url)
        
        // it's not recursive. below is actually the original open(_:) method
        self.swizzledOpen(url, options: options, completionHandler: completion)
    }
}

func logWalletSegueMessage(url: URL, function: String = #function) {
//    let keyWindow = UIApplication.shared.connectedScenes
//            .filter({$0.activationState == .foregroundActive})
//            .compactMap({$0 as? UIWindowScene})
//            .first?.windows
//            .filter({$0.isKeyWindow}).first
    print("Wallet message \(url) \(function)")
//    if let vc = keyWindow?.rootViewController as? ViewController {
//        vc.logURL(url, function: function)
//    }
}
