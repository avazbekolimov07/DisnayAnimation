//
//  CustomTabBar.swift
//  CustomTabBar
//
//  Created by 1 on 13/09/21.
//

import SwiftUI

import MapKit
import CoreLocationUI
import CoreLocation

struct CustomTabBarView: View {
    @State var currentTab : Tab = .Home
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    @Namespace var animation
    @State var currentXValue: CGFloat = 0
    
    var body: some View {
        TabView(selection: $currentTab) {
//            Text("Home")
            HomeView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("Gradient1").ignoresSafeArea())
                .tag(Tab.Home)
            IsLikedView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("Gradient1").ignoresSafeArea())
                .tag(Tab.Search)
            CoreLocationView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("Gradient1").ignoresSafeArea())
                .tag(Tab.Notification)
            SlideAnimationView()
//            Text("Settings")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("Gradient1").ignoresSafeArea())
                .tag(Tab.Account)
        }
        .overlay(
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    TabButton(tab: tab) //TabButton is View
                }
            } //:HSTACK
                .padding(.vertical)
                .padding(.bottom,getSafeArea().bottom == 0 ? 0 : (getSafeArea().bottom))
                .background(
                    MaterialEffect(style: .systemMaterialDark) // effect
                        .clipShape(BottomCurve(currentXValue: currentXValue))
                )
            ,alignment: .bottom // to show TAB in bottom
        ) //: overlay
            .ignoresSafeArea(.all, edges: .bottom)
            .preferredColorScheme(.dark)
    }
    
    @ViewBuilder
    func TabButton(tab : Tab) -> some View {
        GeometryReader { proxy in
            Button {
                withAnimation(.spring()) {
                    currentTab = tab
                    // updating Value
                    currentXValue = proxy.frame(in: .global).midX
                }
            } label: {
                Image(systemName: tab.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding(currentTab == tab ? 15 : 0)
                    .background(
                        ZStack {
                            if currentTab == tab {
                                MaterialEffect(style: .systemChromeMaterialDark) //effect
                                    .clipShape(Circle())
                                // tanlangan tab ga circle yurishi
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            }
                        } //: ZSTACK
                    ) //: background
                    .contentShape(Rectangle())
                    .offset(y: currentTab == tab ? -50 : 0)
                    .onAppear() {
                        if tab == Tab.allCases.first && currentXValue == 0 {
                            currentXValue = proxy.frame(in: .global).midX
                        }
                    }
            }//: Button
        }
        .frame(height: 30)
    } //func view
} // CustomBarView

struct CustomTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBarView()
      
    }
}

enum Tab: String, CaseIterable {
    case Home = "house.fill"
    case Search = "magnifyingglass"
    case Notification = "bell.fill"
    case Account = "person.fill"
}

extension View {
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
            }
        return safeArea
    }// func
}// extension
