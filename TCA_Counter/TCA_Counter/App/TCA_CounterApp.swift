//
//  TCA_CounterApp.swift
//  TCA_Counter
//
//  Created by 강창현 on 3/21/24.
//

import ComposableArchitecture
import SwiftUI

@main
struct TCA_CounterApp: App {
    @StateObject var counterFeature: CounterFeature = CounterFeature()
    var body: some Scene {
        WindowGroup {
//            ContentView_TCA(
//              store: Store(initialState: CounterFeature_TCA.State()) {
//                CounterFeature_TCA()
//              }
//            )
            ContentView()
                .environmentObject(counterFeature)
        }
    }
}
