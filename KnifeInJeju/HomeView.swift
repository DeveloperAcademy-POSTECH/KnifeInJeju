//
//  HomeView.swift
//  KnifeInJeju
//
//  Created by 김예훈 on 2022/04/06.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var queryQuestions: [Question] = []
    @Published var queryString = ""
    
    // 백엔드 존재 시 데이터베이스에 쿼리하는 코드가 들어감. but 없으므로 더미 데이터에 쿼리함.
    func getQueryQuestions(user: User) {
        
        if let data = Storage.retrive(Storage.databaseAllQuestionURL, from: .documents, as: [Question].self) {
            let filteredData = data.filter { question in
                //let queryedText = question.text + question.title
                return question.isAnswered && question.to.id != user.id
            }
            queryQuestions = filteredData
        } else {
            Storage.store(Question.dummyData, to: .documents, as: Storage.databaseAllQuestionURL)
            getQueryQuestions(user: user)
        }
    }
    
    func saveQueryQuestions(string: String, user: User) {
        // questions을 순회하며 원본 데이터베이스 파일에 있는 question과 같은 id를 찾으면 직접 변경해주고 다시 저장해줌
        if var data = Storage.retrive(Storage.databaseAllQuestionURL, from: .documents, as: [Question].self) {
            queryQuestions.forEach { question in
                if let index = data.firstIndex(where: { $0.id == question.id }) {
                    data[index] = question
                }
            }
            Storage.store(data, to: .documents, as: Storage.databaseAllQuestionURL)
            getQueryQuestions(user: user)
        } else {
            fatalError("Failed Get Database In saveQuestions()")
        }
    }
}

struct HomeView: View {
    @EnvironmentObject var loginUserVM: LoginUserViewModel
    @StateObject var vm = HomeViewModel()
    @State var selection: Int? = nil
    @State var answerButtonToggle = false
    
    var body: some View {
        NavigationView{
            VStack {
                Image("qlog")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:300, height: 50, alignment: .leading)
                    .padding(.top)
                
                // Caution
                HStack(alignment: .center, spacing:12) {
                    questionButton
                        .padding()
                    answerButton
                    roleModelButton
                }
                .padding(30)
                
                recentQuestions
            }
            .onAppear{
                loginUserVM.getLoginUser()
                vm.getQueryQuestions(user: loginUserVM.user)
            }
            .navigationTitle(Text("홈"))
            .navigationBarHidden(true)
        }
    }
    
    private var questionButton: some View {
        NavigationLink(destination: RoleModelSelectView(), tag: 1, selection: $selection) {
            Button{
                print("질문하기")
                self.selection = 1
            } label: {
                Text("Question")
                    .opacity(0)
            }
        }
        .buttonStyle(SelectButtonStyle(image: "person.crop.circle.badge.questionmark.fill", text: "질문하기"))
    }
    
    private var answerButton: some View {
        NavigationLink(destination: ReplyView(), tag: 2, selection: $selection) {
            Button{
                answerButtonToggle = true
                print("답변하기")
                self.selection = 2
            } label: {
                Text("Answer")
                    .opacity(0)
            }
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
                .frame(maxWidth: .infinity)
                .foregroundColor(Color(0xF2F2F7))
                .padding()
            
            VStack(spacing: 15) {
                Text("최근 질문")
                    .font(.system(size: 20, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .top], 20)
                list
                    .padding(.horizontal)
            }
            .padding()
        }
    }
    
    
    private var list: some View {
        ScrollView {
            ForEach($vm.queryQuestions) { $question in
                CardView(question: $question, loginUserVM: loginUserVM) {
                    vm.saveQueryQuestions(string: vm.queryString, user: loginUserVM.user)
                }
            }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(LoginUserViewModel())
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
