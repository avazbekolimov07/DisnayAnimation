//
//  SplashScreen.swift
//  SplashScreen
//
//  Created by 1 on 13/09/21.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State var startAnimation = false
    @State var bowAnimation = false
    
    @State var glow = false
    @State var isFinished = false
    
    var body: some View {
        HStack {
            if !isFinished {
                ZStack {
                    Color("BG")
                        .ignoresSafeArea()
                    
                    // Disney Logo
                    GeometryReader { proxy in
                        let size = proxy.size
                        ZStack {
                            // Rainbow
                            Circle()
                                .trim(from: 0, to: bowAnimation ? 0.5 : 0)
                                .stroke(
                                    .linearGradient(.init(colors: [
                                        Color("Gradient1"),
                                        Color("Gradient2"),
                                        Color("Gradient3"),
                                        Color("Gradient5"),
                                        Color("Gradient5")
                                            .opacity(0.5),
                                        Color("GradientBG"),
                                        Color("GradientBG"),
                                        Color("GradientBG"),
                                    ]), startPoint: .leading, endPoint: .trailing)
                                    ,style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
                                )
                                .overlay(
                                    Circle()
                                        .fill(Color.white.opacity(0.4))
                                        .frame(width: 6, height: 6)
                                        .overlay(
                                            Circle()
                                                .fill(Color.white.opacity(glow ? 0.2 : 0.1))
                                                .frame(width: 20, height: 20)
                                        )
                                        .blur(radius: 2.5)
                                    //moving towatds left
                                        .offset(x: (size.width / 2.2) / 2)
                                    //moving towards bow
                                        .rotationEffect(.init(degrees: bowAnimation ? 180 : 0))
                                        .opacity(startAnimation ? 1 : 0)
                                )
                                .frame(width: size.width / 3, height: size.height / 3)
                                .rotationEffect(.init(degrees: -180))
                                .offset(y: 5)
                            
                            Image("disney")
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: size.width / 1.5 , height: size.height / 1.5)
                                .foregroundColor(.white)
                                .opacity(bowAnimation ? 1 : 0)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    } //: Geometry
                } //: ZStack
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.linear(duration: 2)) {
                            bowAnimation.toggle()
                        }
                        
                        withAnimation(.linear(duration: 1).repeatForever(autoreverses: true)) {
                            glow.toggle()
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.spring()) {
                                startAnimation.toggle()
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.spring()) {
                                startAnimation.toggle()
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                            withAnimation(.linear(duration: 0.4)) {
                                isFinished.toggle()
                            }
                        }
                    }//Dispatch
                }//: onAppear

            } else {
            
            }
        }
        
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
