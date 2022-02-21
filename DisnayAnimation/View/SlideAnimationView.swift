//
//  SlideAnimationView.swift
//  SlideAnimationView
//
//  Created by 1 on 17/09/21.
//

import SwiftUI


//This project will work for 14iOS also...
struct SlideAnimationView: View {
    
    // CurrentState
    @State var dotState: DotState = .normal
    //Scale Value
    @State var dotScale: CGFloat = 1
    //Scale Rotation
    @State var dotRotation: Double = 0
    //To avoid multipe taps
    @State var isAnimating: Bool = false
    
    var body: some View {
        ZStack {
            ZStack {
                (dotState == .normal ? Color("Gold") : Color("Grey"))
                if dotState == .normal {
                    MinimisedView()
                } else {
                    ExpandedView()
                }
            }
            .animation(.none, value: dotState)
            
            Rectangle()
                .fill(dotState != .normal ? Color("Gold") : Color("Grey"))
                .overlay(
                    ZStack {
                        // Put view in reverse
                        // so it will look like masking effect
                        // changing based on the state
                        if dotState != .normal {
                            MinimisedView()
                        } else {
                            ExpandedView()
                        }
                    } //: ZSTACK
                ) //: OVERLAY
                .animation(.none, value: dotState)
            //Masking the view with circle to create dot inversion animation
                .mask(
                    GeometryReader{ proxy in
                        Circle()
                        //While increasing the scale the content will be visible
                            .frame(width: 100, height: 100)
                            .scaleEffect(dotScale)
                            .rotation3DEffect(.init(degrees: dotRotation), axis: (x: 0, y: 1, z: 0), anchorZ: dotState == .flipped ? -10 : 10, perspective: 1)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            .offset(y: -60)
                        
                    } //: GREADER
                ) //: MASK
            
            //For Tap Gesture
            Circle()
                .foregroundColor(Color.black.opacity(0.01))
                .frame(width: 100, height: 100)
            //Arrow
                .overlay(content: {
                    Image(systemName: "chevron.right")
                        .font(.title)
                        .foregroundColor(.white)
                        .opacity(isAnimating ? 0 : 1)
                        .animation(.easeInOut(duration: 0.4), value: isAnimating)
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .onTapGesture {
                    if isAnimating{return}
                    isAnimating = true
                    
                    // checking if dot is flipped
                    if dotState == .flipped {
                        // Reversing the effect
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.725) {
                            // 1.5/2 = 0.7
                            withAnimation(.linear(duration: 0.7)) {
                                dotScale = 1
                                dotState = .normal
                            } // with animation
                        }
                        
                        withAnimation(.linear(duration: 1.5)) {
                            dotRotation = 0
                            dotScale = 5
//                          dotState = .flipped
                        } // with animation
                        
                    }
                    else {
                        // At mid of 1.5 just resetting the scale to again 1
                        // so that it will be look like dot inversion
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.725) {
                            // 1.5/2 = 0.7
                            withAnimation(.linear(duration: 0.7)) {
                                dotScale = 1
                                dotState = .flipped
                            } // with animation
                        }
                        
                        withAnimation(.linear(duration: 1.5)) {
                            dotRotation = -180
                            dotScale = 5
//                          dotState = .flipped
                        } // with animation
                    }
                    
                    //After 1.4s resetting isAnimation State
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                        isAnimating = false
                    }
                    
                } // TAP gesture
                .offset(y: -60)
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func ExpandedView() ->  some View {
        VStack(spacing: 10) {
            Image(systemName: "ipad")
                .font(.system(size: 145))
            
            Text("iPad")
                .font(.system(size: 38).bold())
        }
        .foregroundColor(.white)
    }
    
    @ViewBuilder
    func MinimisedView() ->  some View {
        VStack(spacing: 10) {
            Image(systemName: "applewatch")
                .font(.system(size: 145))
            
            Text("Apple Watch")
                .font(.system(size: 38).bold())
        }
        .foregroundColor(.white)
    }

}

struct SlideAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        SlideAnimationView()
    }
}

//Enum for current Dot State
enum DotState {
    case normal
    case flipped
}
