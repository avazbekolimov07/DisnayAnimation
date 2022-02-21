//
//  Home.swift
//  Home
//
//  Created by 1 on 14/09/21.
//

import SwiftUI

struct HomeView: View {
    @State var isConnected = false
    @State var currentServer: Server = servers.first!
    @State var changeServer = false
    
    var body: some View {
        VStack {
            HStack {
                
                Button {
                    
                } label: {
                    Image(systemName: "circle.grid.cross")
                        .font(.title2)
                        .padding(12)
                        .background(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(.white.opacity(0.4),lineWidth: 1)
                        )
                } //: BUTTON
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.title2)
                        .padding(12)
                        .background(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(.white.opacity(0.4),lineWidth: 1)
                        )
                } //: BUTTON
                
            } //: HSTACK
            .overlay(
                Text(getTitle())
            )
            .foregroundColor(Color.white)
            
            PowerButton()
            
            //Status with letter
            VStack {
                Label {
                    Text(isConnected ? "Connected" : "Not Connected")
                } icon: {
                    Image(systemName: isConnected ? "checkmark.shield" : "shield.slash")
                }
                .font(.system(size: 18, weight: .semibold))
                
                Spacer()
                
                HStack {
                    HStack {
                        Image(systemName: "arrow.down.to.line.circle")
                            .font(.title2)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Download")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                            
                            Text("\(isConnected ? "60.0" : "0") KB/s")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "arrow.up.to.line.circle")
                            .font(.title2)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Upload")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                            
                            Text("\(isConnected ? "27.5" : "0") KB/s")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                        }
                    }
                } //: HSTACK
                .frame(width: getRect().width - 100)
            } //: VSTACK
            .animation(.none, value: isConnected)
            .frame(height: 120)
            .padding(.top, getRect().height < 750 ? 20 : 40)
            
        } //: VSTACK
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            Background()
        )
        .overlay(
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(changeServer ? 1 : 0)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        changeServer.toggle()
                    }
                }
        )
        .overlay(
            BottomSheet(),
            alignment: .bottom
        )
        //Blur View when server page shows
        .ignoresSafeArea(.container, edges: .bottom)
        .preferredColorScheme(.dark)
    }
    
    
    func getTitle() -> AttributedString {
        var str = AttributedString("MicroVPN")
        
        if let range = str.range(of: "Micro") {
            str[range].font = .system(size: 24, weight: .light)
        }
        
        if let range = str.range(of: "VPN") {
            str[range].font = .system(size: 24, weight: .black)
        }
        return str
    } //: function
    
    // View Builder
    @ViewBuilder
    func BottomSheet() ->some View {
        VStack(spacing: 0) {
            HStack {
                Image(currentServer.flag)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(currentServer.name)
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text(isConnected ? "Currently Connected" : "Currently selected")
                        .font(.caption2.bold())
                } //: VSTACK
                
                Spacer(minLength: 10)
                
                Button {
                    withAnimation {
                        changeServer.toggle()
                    }
                } label: {
                    Text(changeServer ? "Exit" : "Change")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(width: 110, height: 45)
                        .background(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(.white.opacity(0.25), lineWidth: 2)
                        )
                        .foregroundColor(.white)
                } //: BUTTON
            } //: HSTACK
            .frame(height: 50) //1?
            .padding(.horizontal)
            
            Divider()
                .padding(.top)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    //Filtered Server
                    //Not showing selected One
                    ForEach(servers.filter {
                        $0.id != currentServer.id
                    }) { server in
                        VStack(spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(server.flag)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                        
                                        Text(server.name)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                    } //: HSTACK
                                    Label {
                                        Text("Available, Ping 992ms")
                                    } icon: {
                                        Image(systemName: "chemkmark")
                                    }
                                    .foregroundColor(.green)
                                    .font(.caption2)
                                }//: VSTACK
                                
                                Spacer(minLength: 10)
                                
                                Button {
                                    withAnimation {
                                        changeServer.toggle()
                                        currentServer = server
                                        isConnected = false
                                    }
                                } label: {
                                    Text("Change")
                                        .font(.callout)
                                        .fontWeight(.semibold)
                                        .frame(width: 100, height: 45)
                                        .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .strokeBorder(.white.opacity(0.25), lineWidth: 2)
                                        )
                                        .foregroundColor(.white)
                                } //: BUTTON
                                
                                Button {
                                     
                                } label: {
                                    Image(systemName: "square.and.arrow.up")
                                    .frame(width: 45, height: 45)
                                    .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(.white.opacity(0.25), lineWidth: 2)
                                    )
                                    .foregroundColor(.white)
                                }
                            } //: HSTACK
                            .frame(height: 50)
                            .padding(.horizontal)
                            
                            Divider()
                        } //:VSTACK
                    } //: LOOP
                } //: VTSACK
                .padding(.top, 25)
                .padding(.bottom, getSafeArea().bottom + 50) //2?
            } //: SCROLL
            .opacity(changeServer ? 1 : 0)
        } //: VSTACK
        .frame(maxWidth: .infinity)
        .frame(height: getRect().height / 2.5, alignment: .top) //3?
        .padding()
        .background(
        Color("BottomSheet")
            .clipShape(CustomCorners(radius: 35, corners: [.topLeft,.topRight]))
        )
        .offset(x: 25 ,y: changeServer ? 0 : (getRect().height / 2.5) - (75 + 50 + getSafeArea().bottom)) //4?
        
        
    }// viewbuilder
    
    @ViewBuilder
    func Background() -> some View {
        ZStack {
            LinearGradient(colors: [
                Color("BG1"),
                Color("BG1"),
                Color("BG2"),
                Color("BG2"),
            ], startPoint: .top, endPoint: .bottom)
            //little planet and little stars
            Image("mars")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 30, height: 30)
                .scaleEffect(getRect().height < 750 ? 0.8 : 1)
                .position(x: 50, y: getRect().height < 750 ? 200 : 220)
                .opacity(0.7)
                
            //sample star points
            let stars: [CGPoint] = [
            CGPoint(x: 15, y: 190),
            CGPoint(x: 25, y: 250),
            CGPoint(x: 20, y: 350),
            CGPoint(x: getRect().width - 30, y: 240),
            ]
            
            ForEach(stars, id: \.x) { star in
                Circle()
                    .fill(.white.opacity(0.3))
                    .frame(width: 5, height: 5)
                    .position(star)
                    .offset(y: getRect().height < 750 ? -20 : 0)
            }
            
            //globe at Bottom
            Image("globe")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: getRect().width, height: getRect().height)
                .scaleEffect(1.5)
                .offset(y: getRect().height < 720 ? 310 * 1.7 : 280 * 1.7)
            // moving to bottom
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        } //: ZSTACK
            .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func PowerButton() -> some View {
        Button {
            withAnimation {
                isConnected.toggle()
            }
        } label: {
            ZStack {
                Image(systemName: "power")
                    .font(.system(size: 65, weight: .medium))
                    .foregroundColor(isConnected ? .white : Color("Power"))
                    .scaleEffect(isConnected ? 0.7 : 1)
                    .offset(y: isConnected ? -30 : 0)
                
                Text("Disconnected".uppercased())
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .offset(y: 20)
                    .opacity(isConnected ? 1 : 0)
            } //: ZSTACK
            
                //max Frame
                .frame(width: 190, height: 190)
                .background(
                    ZStack {
                        Circle()
                            .trim(from: isConnected ? 0 : 0.3, to: isConnected ? 1 : 0.5)
                            .stroke(
                            LinearGradient(colors: [
                                Color("Ring1"),
                                Color("Ring1")
                                    .opacity(0.5),
                                Color("Ring1")
                                    .opacity(0.3),
                                Color("Ring1")
                                    .opacity(0.1),
                            ], startPoint: .leading, endPoint: .trailing),
                            style: StrokeStyle(lineWidth: 11, lineCap: .round, lineJoin: .round)
                            ) //: stroke
                            .shadow(color: Color("Ring1"), radius: 5, x: 1, y: -4)
                        
                        Circle()
                            .trim(from: isConnected ? 0 : 0.3, to: isConnected ? 1 : 0.55)
                            .stroke(
                            LinearGradient(colors: [
                                Color("Ring2"),
                                Color("Ring2")
                                    .opacity(0.5),
                                Color("Ring2")
                                    .opacity(0.3),
                                Color("Ring2")
                                    .opacity(0.1),
                            ], startPoint: .leading, endPoint: .trailing),
                            style: StrokeStyle(lineWidth: 11, lineCap: .round, lineJoin: .round)
                            ) //: stroke
                            .shadow(color: Color("Ring2"), radius: 5, x: 1, y: -4)
                            .rotationEffect(.init(degrees: 170))
                        
                        //Main little Ring
                        Circle()
                            .stroke(
                            Color("Ring1")
                                .opacity(0.01),lineWidth: 11
                            )
                            .shadow(color: Color("Ring2").opacity(isConnected ? 0.04 : 0.0), radius: 5, x: 1, y: -4)
                        
                    } //: ZSTACK
                ) //: BACKGROUND
        } //: BUTTON
        .padding(.top, getRect().height < 750 ? 30 : 100)

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

extension View {
    func getRect() -> CGRect {
        UIScreen.main.bounds
    }
    //WE HAVE GET_SAFE_AREA IN CUSTOMTABVIEW
    
//    func getSafeArea() -> UIEdgeInsets {
//        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
//            return .zero
//        }
//
//        guard let safeArea = screen.windows.first?.safeAreaInsets else {
//            return .zero
//    }
//        return safeArea
//    }
}
