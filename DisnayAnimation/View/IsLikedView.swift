//
//  IsLikedView.swift
//  IsLikedView
//
//  Created by 1 on 16/09/21.
//

import SwiftUI

struct IsLikedView: View {
   
    @State var posts: [Post] = [
    Post(imageName: "cover-1"),
    Post(imageName: "cover-2"),
    Post(imageName: "cover-3"),
    Post(imageName: "cover-4"),
    ]
    
    var body: some View {
        
        NavigationView {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(posts) { post in
                        VStack(alignment: .leading, spacing: -2) {

                                Image(post.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(15)
                                    .frame(width: 140, height: 240, alignment: .leading)
//
                            //Adding overlay
                                    .overlay(
                                        HeartLiked(isTapped: $posts[getIndex(post: post)].isLiked, taps: 2)
                                    )
                                    .cornerRadius(15)
                            
                                Button {
                                posts[getIndex(post: post)].isLiked.toggle()
                                } label: {
                                Image(systemName: post.isLiked ? "suit.heart.fill" : "suit.heart")
                                    .font(.title2)
                                    .foregroundColor(post.isLiked ? .red : .gray)
                                } //: Button
                                .padding(.leading, 15) //user

                        } //: VSTACK
                    } //: LOOP
                } //: VSTACK
                .padding()
            } //: SCROLL
            .navigationTitle("Heart Animation")
        } //: NavigationView
    }
    // getting index
    func getIndex(post: Post)-> Int {
        let index = posts.firstIndex { currentPost in
            return currentPost.id == post.id
        } ?? 0
        return index
    }
}


struct HeartLiked: View {
    @Binding var isTapped: Bool
    @State var startAnimation: Bool = false
    @State var bgAnimation: Bool = false
    @State var resetBG: Bool = false
    @State var fireworkAnimation: Bool = false
    @State var animationEnds: Bool = false
    //To avoid Taps during Animation
    @State var tapComplete: Bool = false
    //Setting how many taps
    var taps: Int = 1
    
    var body: some View {
        // Heart liked Animation
        Image(systemName: resetBG ? "suit.heart.fill" : "suit.heart")
            .font(.system(size: 35))
            .foregroundColor(resetBG ? .red : .gray)
        //Scale effect
            .scaleEffect(startAnimation && !resetBG ? 0 : 1)
            .opacity(startAnimation && !animationEnds ? 1 : 0)
        // BG
            .background(
                ZStack {
                    CustomShape(radius: resetBG ? 29 : 0)
                        .fill(Color.purple)
                        .clipShape(Circle())
                        .frame(width: 50, height: 50) //
                        .scaleEffect(bgAnimation ? 2.2 : 0)
                    ZStack {
                        let colors: [Color] = [.red, .purple, .green, .yellow, .pink]
                        ForEach(1...6,id: \.self) { index in
                            
                            Circle()
                                .fill(colors.randomElement()!)
                                .frame(width: 12, height: 12)
                                .offset(x: fireworkAnimation ? 50 : 20)
                                .rotationEffect(.init(degrees: Double(index) * 60))
                        } //: LOOP
                        
                        ForEach(1...6,id: \.self) { index in
                            
                            Circle()
                                .fill(colors.randomElement()!)
                                .frame(width: 8, height: 8)
                                .offset(x: fireworkAnimation ? 44 : 5)
                                .rotationEffect(.init(degrees: Double(index) * 60))
                                .rotationEffect(.init(degrees: -45))
                        } //: LOOP
                    } //: ZSTACK
                }
                    .opacity(resetBG ? 1 : 0)
                    .opacity(animationEnds ? 0 : 1)
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .contentShape(Rectangle())
            .onTapGesture(count: taps) {
                
                if tapComplete {
                    updateFields(value: false)
                    return
                }
                
                if startAnimation {
                    return
                }
                
                isTapped = true
                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
                    startAnimation = true
                } // WITHanimation
                
                //Sequence Animation
                //Chain Animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)) {
                        bgAnimation = true
                    } // WITHanimation
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
                            resetBG = true
                        } // WITHanimation
                        
                        //Fireworks
                        withAnimation(.spring()) {
                            fireworkAnimation = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            withAnimation(.easeOut(duration: 0.4)) {
                                animationEnds = true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                tapComplete = true
                            }// TapCOMPLETE
                            
                        } //AnimationEnds
                        
                    } //Dispatch inner
                } //Dispatch outter
            } //TapGESTURE
            .onChange(of: isTapped) { newValue in
                if isTapped && !startAnimation {
                    updateFields(value: true)
                }
                
                if !isTapped {
                    updateFields(value: false)
                }
            }
    }
    
    func updateFields(value: Bool) {
        startAnimation = value
        bgAnimation = value
        resetBG = value
        fireworkAnimation = value
        animationEnds = value
        tapComplete = value
        isTapped = value
    }
}

struct IsLikedView_Previews: PreviewProvider {
    static var previews: some View {
        IsLikedView()
    }
}

//Custom Shape
//For Reseting from centre
struct CustomShape: Shape {
    //value
    var radius: CGFloat
    
    //animating Path
    var animatableData: CGFloat {
        get{return radius}
        set{radius = newValue}
    }
    
    //Animating Path wont work on preview
    
    func path(in rect: CGRect) -> Path {
        return Path{ path in
            path.move(to: CGPoint(x: 0, y: 0))

            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            
            // adding Centre Circle
            let centre = CGPoint(x: rect.width / 2, y: rect.height / 2)
            path.move(to: centre)
            path.addArc(center: centre, radius: radius, startAngle: .zero, endAngle: .init(degrees: 360), clockwise: false)
            
        }
    }
}
