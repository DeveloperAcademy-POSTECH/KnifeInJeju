//
//  HomeView.swift
//  KnifeInJeju
//
//  Created by 김예훈 on 2022/04/06.
//

import SwiftUI

struct HomeView: View {
    @State var countQlog: Int = 0
    
    var body: some View {
        NavigationView{
            VStack {
                Text("Qlog")
                    .font(.system(size: 34.0, weight: .bold))
                    .frame(width:320, height: 45, alignment: .leading)
                HStack {
                    SelectButton(inputText: "질문하기")
                    SelectButton(inputText: "답변하기")
                }
                HStack {
                    newQlog
                    roleModelBar
                }
                Spacer(minLength: 13)
                VStack {
                        Rectangle()
                            .frame(height: 424)
                            .foregroundColor(Color(0xF2F2F7))
                        // CardView
                    }
            }
            .navigationTitle(Text("홈"))
            .navigationBarHidden(true)
        }
        
    }
    
    // new Qlog View
    private var newQlog: some View {
        Text("\(countQlog) new Qlog")
            .fontWeight(.bold)
            .foregroundColor(Color.gray)
            .multilineTextAlignment(.leading)
            .frame(width: 100.0, height: 30.0)
    }
    
    // My Role Model Bar
    private var roleModelBar: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color(0x0C4767), lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 10)
                    .fill(Color(0x0C4767, alpha: 0.1)))
                .frame(width: 235, height: 32)
            
            HStack {
                Text("My Role Model")
                    .font(.system(size: 13, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .padding(.trailing, 70.0)
                roleModelNavigation
            }
        }
    }
    
    // 롤모델 관리 화면으로 Navigatoin Link
    private var roleModelNavigation: some View {
        NavigationLink(destination: RoleModelView()) {
            Image(systemName: "chevron.down")
                .padding(.leading)
                .font(.system(size: 13.0, weight: .bold))
                .foregroundColor(.black)
        }
    }
    
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
        RoleModelView()
    }
}

// 질문하기, 답변하기 버튼
struct SelectButton: View {
    var inputText: String
    // var openView: View
    
    var body: some View {
        Button(action: {
            // go to new view
        }) {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray)
                .foregroundColor(.white)
                .overlay(Text("\(inputText)"))
        }
        .frame(width: 147, height: 152)
        .padding(10)
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
