//
//  ContentView.swift
//  DisnayAnimation
//
//  Created by 1 on 13/09/21.
//

import SwiftUI

import MapKit
import CoreLocationUI
import CoreLocation

struct ContentView: View {
    var body: some View {
        NavigationView {
            
                CustomTabBarView()
                    
            }
        .overlay(SplashScreenView())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
