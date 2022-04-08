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
                    SelectButton(inputImage: "person.crop.circle.badge.questionmark.fill", inputText: "질문하기")
                    SelectButton(inputImage: "exclamationmark.bubble.fill",inputText: "답변하기")
                    SelectButton(inputImage: "person.fill.checkmark",inputText: "내 롤모델")
                    
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
    var inputImage: String
    var inputText: String
    // var openView: View
    
    var body: some View {
        Button(action: {
            // go to new view
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(0xFF9407, alpha: 0.7))
                    .frame(width: 100, height: 140)
                VStack {
                    ZStack {
                        Color.white
                            .cornerRadius(10, corners: [.topRight, .topLeft])
                            .frame(width: 94, height: 94)
                        Image(systemName: "\(inputImage)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 45, height: 45)
                    }
                    .padding(.bottom, 6)
                    Text("\(inputText)")
                        .font(.system(size: 15.0, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.bottom, 9)
                }
            }
        }
    }
}

// Clipped Rounded Rectangle
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// View Extension for cornerRadius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
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
