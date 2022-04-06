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
                RoundedRectangle(cornerRadius: 20)
                    .fill(self.color)
                    .shadow(color: self.color.opacity(1), radius: 10)
                    .background(Color.white)
                    .frame(width: 300, height: 400)
                    .padding()
                Text("\(self.num)")
                    .font(.system(size: 35))
                    .bold()
            }.rotation3DEffect(
                Angle(
                    degrees: Double((geometry.frame(in: .global).maxY - self.maxY) + self.maxY/2) / 5),
                axis: (x: -1.0, y: 0.0, z: 0.0)
            )
        }
    }
}


struct SelectButton: View {
    var inputText: String
    
    var body: some View {
        Button(action: {}) {
            Text("\(inputText)")
        }
        .frame(width: 150, height: 150)
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
        .padding()
    }
}


struct RoleModelBar: View {
    var body: some View {
        Text("Hello")
    }
}


struct HomeView: View {
    var colors = [Color.red.opacity(0.3), Color.yellow.opacity(0.3),
                  Color.green.opacity(0.3), Color.blue.opacity(0.3),
                  Color.purple.opacity(0.3), Color.white.opacity(0.3)]
    
    var body: some View {

        VStack {
            Text("Qlog")
                .font(.system(size: 50))
                .frame(width:340, height: 50, alignment: .leading)
            Spacer()
            HStack {
                SelectButton(inputText: "질문하기")
                SelectButton(inputText: "대답하기")
            }
            RoleModelBar()
            Spacer()
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false){
                    VStack(spacing: geometry.size.width/1.5) { // Control Overlap
                        
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
