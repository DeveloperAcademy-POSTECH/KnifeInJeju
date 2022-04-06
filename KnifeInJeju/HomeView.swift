//
//  HomeView.swift
//  KnifeInJeju
//
//  Created by 김예훈 on 2022/04/06.
//

import SwiftUI

struct GraphicCardView: View {
    let num: Int
    let color: Color
    let maxY = UIScreen.main.bounds.maxY
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(self.color)
                    .shadow(color: self.color.opacity(1), radius: 10)
                    .background(Color.white)
                    .frame(width: 300, height: 300)
                    .padding()
                Text("\(self.num)")
                    .font(.system(size: 35))
                    .bold()
            }.rotation3DEffect(
                Angle(
                    degrees: Double((geometry.frame(in: .global).maxY - self.maxY) + self.maxY/2) / 7),
                axis: (x: -1.0, y: 0.0, z: 0.0)
            )
        }.padding()
    }
}


struct SelectButton: View {
    var inputText: String
    
    var body: some View {
        Button(action: {}) {
            Text("\(inputText)")
        }
        .frame(width: 150, height: 150)
        .background(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2))
        .padding(10)
    }
}


struct NewQlogView: View {
    @State var countQlog: Int = 0
    
    var body: some View {
        Text("\(countQlog) new Qlog")
            .fontWeight(.bold)
            .foregroundColor(Color.gray)
            .multilineTextAlignment(.leading)
            .frame(width: 100.0, height: 30.0)
    }
}

struct RoleModelBar: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color(0x0C4767), lineWidth: 1)
                .frame(width: 235, height: 32)
                .background(Color(0x0C4767, alpha: 0.1))
            
            HStack {
                Text("My Role Model")
                    .font(.system(size: 13, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .padding(.trailing, 70.0)
                Button(action: {}) {
                    Image(systemName: "chevron.down")
                        .padding(.leading)
                        .font(.system(size: 13.0, weight: .bold))
                        .foregroundColor(.black)
                }
            }
        }
    }
}



struct HomeView: View {
    var colors = [Color.white.opacity(0.3), Color.red.opacity(0.3),                              Color.yellow.opacity(0.3), Color.green.opacity(0.3),                           Color.blue.opacity(0.3), Color.purple.opacity(0.3),                            Color.white.opacity(0.3)]
    
    var body: some View {

        VStack {
            Text("Qlog")
                .font(.system(size: 34.0, weight: .bold))
                .frame(width:320, height: 45, alignment: .leading)
            Spacer()
            HStack {
                SelectButton(inputText: "질문하기")
                SelectButton(inputText: "답변하기")
            }
            HStack {
                NewQlogView()
                RoleModelBar()
            }
            Spacer()
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false){
                    VStack(spacing: geometry.size.width/1.3) { // Control Overlap
                        
                        ForEach(0..<self.colors.count, id: \.self) { index in
                            ZStack {
                                GraphicCardView(num: index+1, color: self.colors[index])
                            }
                        }
                    }.padding()//.padding(.vertical, geometry.frame(in: .global).maxY/2)
                }
            }
        }
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


// Color Extension for hex Code
extension Color {
    init(_ hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255,
            opacity: alpha
        )
    }
}
