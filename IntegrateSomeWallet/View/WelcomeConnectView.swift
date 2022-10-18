//
//  WelcomeView.swift
//  IntegrateSomeWallet
//
//  Created by javi www on 10/18/22.
//

import SwiftUI
import CoinbaseWalletSDK

struct WelcomeView: View {
    
    @State var hueRot = 0.0
        
//    private lazy var cbwallet = { CoinbaseWalletSDK.shared }()
    
    private let cbwallet = CoinbaseWalletSDK.shared
    @State private var address: String?
    
    var body: some View {
        
        ZStack {
            
            //MARK: Background blur
            ZStack {
                Color("BG")
                
                Circle()
                    .fill(Color("G1").gradient)
                    .blur(radius: 80)
                    .offset(x: -200, y: -300)
                    .scaleEffect(1.1)
                
                Circle()
                    .fill(Color("G2").gradient)
                    .blur(radius: 80)
                    .offset(x: 200, y: -200)
                    .scaleEffect(1.4)
            }
            .ignoresSafeArea()
            
            //MARK: Logo and text
            VStack(spacing: -20) {
                ZStack {
                    Image("MoneyWalletIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .hueRotation(.init(degrees: 100.66))
                    
                }
                .frame(width: 220, height: 220)
                
                Text("JAVIWALLET")
                    .font(.custom("VictorMono-BoldItalic", size: 40))
            }
            .offset(y: -140)
            
            //MARK: Bottom Text and buttons
            VStack(spacing: 24) {
                Text("Your tokens will be safe and secure in javiwallet.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 44)
                    .font(.title3)
                    .padding(.bottom, 24)
                    .opacity(0.8)
                
                let paddingHorinzontalButtons:CGFloat = 100
                Button {
                     connectCoinbaseWalletAction()
                } label: {
                    Text("Connect Wallet")
                        .font(.title3.bold())
                }
                .padding(.horizontal, paddingHorinzontalButtons)
                .padding(.vertical, 16)
                .background {
                    Capsule()
                        .fill(Color("Orange"))
                }
                
                Button {
                     
                } label: {
                    Text("Restore Wallet")
                        .font(.title3.bold())
                }
                .padding(.horizontal, paddingHorinzontalButtons)
                .padding(.vertical, 16)
                .background {
                    Capsule()
                        .stroke(Color("Orange"))
                }
                
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, 94)
        }
        
    }
    
    func connectCoinbaseWalletAction() {
        cbwallet.initiateHandshake(
            initialActions: [
                Action(jsonRpc: .eth_requestAccounts)
            ]
        ) { result, account in
            switch result {
            case .success(let response):
                logObject(label: "Response:\n", response.callbackUrl)

                guard let account = account else { return }
                logObject(label: "Account:\n", account)
                self.address = account.address
            case .failure(let error):
                print("\(error)")
            }
            self.updateSessionStatus()
        }
    }
    
    private func updateSessionStatus() {
        DispatchQueue.main.async {
            let isConnected = self.cbwallet.isConnected()
            print("\(isConnected)")
            
            print("\(self.cbwallet.ownPublicKey.rawRepresentation.base64EncodedString())")
                  print("\(self.cbwallet.peerPublicKey?.rawRepresentation.base64EncodedString() ?? "(nil)")")
        }
    }
    
    func logObject<T: Encodable>(label: String = "", _ object: T, function: String = #function) {

    }

}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            
            //Base design image to pixel perfect match
            GeometryReader {
                let size = $0.size
                Image("WelcomeMain")
                    .frame(width: size.width, height: size.height)
                    .scaleEffect(1.05)
                    .opacity(0.0)
            }
            .ignoresSafeArea()
            
            ContentView()
        }
    }
}
