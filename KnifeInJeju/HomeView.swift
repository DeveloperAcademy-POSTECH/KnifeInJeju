//
//  HomeView.swift
//  KnifeInJeju
//
//  Created by 김예훈 on 2022/04/06.
//

import SwiftUI

struct HomeView: View {
    @State var selection: Int? = nil
    @State var answerButtonToggle = false
    
    var body: some View {
        NavigationView{
            VStack {
                Text("Qlog")
                    .font(.system(size: 34.0, weight: .bold))
                    .frame(width:320, height: 45, alignment: .leading)
                    .padding(.bottom, 30)
                HStack(spacing: 15) {
                    questionButton
                    answerButton
                    roleModelButton
                }.padding(30)
                Spacer(minLength: 13)
                recentQuestions
            }
            .navigationTitle(Text("홈"))
            .navigationBarHidden(true)
        }
    }
    
    private var questionButton: some View {
        NavigationLink(destination: RoleModelSelectView(), tag: 2, selection: $selection) {
            Button{
                // action
                print("질문하기")
                self.selection = 2
            } label: {
                Text("Question")
                    .opacity(0)
            }
        }
        .buttonStyle(SelectButtonStyle(image: "person.crop.circle.badge.questionmark.fill", text: "질문하기"))
    }
    
    private var answerButton: some View {
        Button{
            answerButtonToggle = true
            print("답변하기")
        } label: {
            Text("Answer")
                .opacity(0)
        }
        .buttonStyle(SelectButtonStyle(image: "exclamationmark.bubble.fill", text: "답변하기"))
    }
    
    private var roleModelButton: some View {
        NavigationLink(destination: RoleModelManageView(), tag: 3, selection: $selection) {
            Button{
                print("내 롤모델")
                self.selection = 3
            } label: {
                Text("MyRoleModel")
                    .opacity(0)
            }
        }.buttonStyle(SelectButtonStyle(image: "person.fill.checkmark", text: "내 롤모델"))
    }
    
    private var recentQuestions: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(0xF2F2F7))
            VStack {
                Text("최근 질문")
                    .font(.system(size: 20, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                    }
                }
            }
        }.padding()
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
        RoleModelManageView()
    }
}

// 3가지 버튼 기본 스타일
struct SelectButtonStyle: ButtonStyle {
    var image: String
    var text: String
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(0xFF9407, alpha: 0.7))
                        .frame(width: 100, height: 140)
                    VStack {
                        ZStack {
                            Color.white
                                .cornerRadius(10, corners: [.topRight, .topLeft])
                                .frame(width: 94, height: 94)
                            Image(systemName: "\(image)")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 45, height: 45)
                                .foregroundColor(Color(0xFF9407))
                        }
                        .padding(.bottom, 6)
                        Text("\(text)")
                            .font(.system(size: 15.0, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.bottom, 9)
                    }
                }
            )
            .scaleEffect(configuration.isPressed ? 0.92: 1)
            .animation(.spring(), value: configuration.isPressed)
            .padding()
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
