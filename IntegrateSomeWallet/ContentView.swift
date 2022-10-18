//
//  ContentView.swift
//  IntegrateSomeWallet
//
//  Created by javi www on 10/10/22.
//

import SwiftUI
import CoinbaseWalletSDK

struct ContentView: View {
    var body: some View {
        WelcomeView()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
