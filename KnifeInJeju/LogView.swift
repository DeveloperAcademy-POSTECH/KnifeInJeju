//
//  LogView.swift
//  KnifeInJeju
//
//  Created by 김예훈 on 2022/04/06.
//

import SwiftUI

class MainUserViewModel: ObservableObject {
    @Published var user: User
     
    init() {
        // 백엔드가 있다면 받아온 유저 ID값으로 쿼리를 해서 User 데이터를 가져옴
        // but 백엔드가 없으니 임시로 User 생성해서 넣어줌
        user = User.dummyMainUserData
        getMainUser()
    }
    
    func getMainUser() {
        guard let data = Storage.retrive(Storage.mainUserURL, from: .documents, as: User.self) else {
            user = User.dummyMainUserData
            saveMainUser()
            return
        }
        user = data
    }
    
    func saveMainUser() {
        Storage.store(user, to: .documents, as: Storage.mainUserURL)
    }
    
    func checkBookmarked(_ question: Question) -> Bool {
        let query = user.bookmarkedQuestions.filter { $0.id == question.id }
        return !query.isEmpty
    }
    
    func checkHearted(_ question: Question) -> Bool {
        let query = user.heartedQuestions.filter { $0.id == question.id }
        return !query.isEmpty
    }
    
    func addBookmark(question: Question) {
        user.bookmarkedQuestions.append(question)
        saveMainUser()
    }
    
    func addHearted(question: Question) {
        user.heartedQuestions.append(question)
        saveMainUser()
    }
    
    @discardableResult
    func removeBookmark(question: Question) -> Bool {
        if let index = user.bookmarkedQuestions.firstIndex(where: { $0.id == question.id }) {
            user.bookmarkedQuestions.remove(at: index)
            saveMainUser()
            return true
        }
        return false
    }
    
    @discardableResult
    func removeHearted(question: Question) -> Bool {
        if let index = user.heartedQuestions.firstIndex(where: {$0.id == question.id}) {
            user.heartedQuestions.remove(at: index)
            saveMainUser()
            return true
        }
        return false
    }
}

class LogViewModel: ObservableObject {
    
    @Published var questions: [Question] = []
    
    func getQuestions(case questionCase: QuestionCase = .toMe, mainUser: User) {
        // 백엔드 데이터베이스 역할을 할 data 변수 ( 로컬에 json 파일로 저장되어 있음)
        if let data = Storage.retrive(Storage.databaseAllQuestionURL, from: .documents, as: [Question].self) {
            
            // 쿼리역할을 해줄 내부 로직 ( LogView(질문 보관함)은 내(MainUser)가 받은, 보낸 질문 중 하나를 세그먼트 컨트롤으로
            // 선택해서 해당 요소만 가져오길 원함.
            switch questionCase {
            case .toMe:
                questions = data.filter { $0.to.id == mainUser.id }
            case .byMe:
                questions = data.filter { $0.from.id == mainUser.id }
            case .other:
                fatalError("Failed by Wrong QuestionCase in getQuestions(case:mainUser:)")
            }
        } else {
            // 저장되어 있는 게 없으면 더미 데이터 저장하고 다시 getQuestion 불러옴, 재귀 무한루프 안빠지게 주의
            Storage.store(Question.dummyData, to: .documents, as: Storage.databaseAllQuestionURL)
            getQuestions(case: questionCase, mainUser: mainUser)
        }
    }
    
    func saveQuestions(case questionCase: QuestionCase = .toMe, mainUser: User) {
        // questions을 순회하며 원본 데이터베이스 파일에 있는 question과 같은 id를 찾으면 직접 변경해주고 다시 저장해줌
        if var data = Storage.retrive(Storage.databaseAllQuestionURL, from: .documents, as: [Question].self) {
            questions.forEach { question in
                if let index = data.firstIndex(of: question) {
                    data[index] = question
                }
            }
            Storage.store(data, to: .documents, as: Storage.databaseAllQuestionURL)
            getQuestions(case: questionCase, mainUser: mainUser)
        } else {
            fatalError("Failed Get Database In saveQuestions()")
        }
    }
}

struct LogView: View {
    @EnvironmentObject var mainUser: MainUserViewModel
    @StateObject var vm = LogViewModel()
    @State private var questionCase: QuestionCase = .toMe
    @State private var onlyBookMark = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                titleHeader
                
                CustomPicker(questionCase: $questionCase)
            }
            .background(.background)
            
            ScrollView {
                VStack(spacing: 20) {
                    Spacer().frame(height: 0)
                    list
                    Spacer().frame(height: 0)
                }
                .padding(.horizontal, 17)
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
        }
        .onChange(of: questionCase) { newValue in
            withAnimation(.spring()) {
                vm.getQuestions(case: newValue, mainUser: mainUser.user)
            }
        }
        .onAppear{
            mainUser.getMainUser()
            vm.getQuestions(mainUser: mainUser.user)
        }
    }
    
    private var titleHeader: some View {
        HStack {
            Text("질문 보관함")
                .font(.title2.weight(.bold))
            Spacer()
            
            HStack {
                Image(systemName: onlyBookMark ? "bookmark.fill" : "bookmark")
                    .foregroundColor(onlyBookMark ? .yellow : .primary)
                Text("북마크 모아보기")
            }
            .font(.footnote.weight(.semibold))
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(Color(.systemGray4))
            )
            .onTapGesture {
                withAnimation(.spring()) {
                    onlyBookMark.toggle()
                }
            }
            .sheet(isPresented: $onlyBookMark) {
                bookmarkedList
            }
        }
        .padding(.horizontal, 17)
        .padding(.top, 20)
    }
    
    private var bookmarkedList: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                Capsule()
                    .fill(.gray.opacity(0.5))
                    .frame(width: 60, height: 5)
                    .padding(.top, 10)
                
                Text("북마크한 질문 \(mainUser.user.bookmarkedQuestions.count)개")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                
                ForEach($mainUser.user.bookmarkedQuestions) { $question in
                    
                    let questionBinding = Binding {
                        question
                    } set: {
                        question = $0
                        mainUser.saveMainUser()
                        vm.saveQuestions(case: questionCase, mainUser: mainUser.user)
                    }
                    
                    CardView(question: questionBinding, mainUser: mainUser)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 17)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6))

    }
    
    private var list: some View {
        ForEach($vm.questions) { $question in
            
            let questionBinding = Binding (
                get: { question },
                set: {
                    question = $0
                    mainUser.saveMainUser()
                    vm.saveQuestions(case: questionCase, mainUser: mainUser.user)
                }
            )
            
            CardView(question: questionBinding, mainUser: mainUser)
        }
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
            .environmentObject(MainUserViewModel())
    }
}

struct UserHeaderView: View {
    
    var user: User
    var date: Date
    
    var body: some View {
        HStack {
            Image(uiImage: UIImage(data: user.profile ?? Data()) ?? UIImage() )
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 28, height: 28)
                .clipShape(Circle())
                .background(
                    ZStack {
                        Circle().fill(Color(.systemGray5))
                        Image(systemName: "photo")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                )
            
            Text(user.name)
                .font(.footnote.bold())
        }
    }
}


struct TagView: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .font(.caption.bold())
            .padding(.vertical, 3)
            .padding(.horizontal, 8)
            .background(
                Capsule()
                    .fill(Color(.systemGray5))
            )
    }
}

enum QuestionCase: String {
    case toMe
    case byMe
    case other
    
    var id: String {
        self.rawValue
    }
}

struct CustomPicker: View {
    
    @Binding var questionCase: QuestionCase
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("받은 질문")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.timingCurve(0.16, 1, 0.3, 1)) {
                            questionCase = .toMe
                        }
                    }
                Text("보낸 질문")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.timingCurve(0.16, 1, 0.3, 1)) {
                            questionCase = .byMe
                        }
                    }
            }
            .font(.footnote.bold())
            
            GeometryReader { geo in
                Rectangle()
                    .frame(width: geo.size.width / 2, height: 5)
                    .frame(maxWidth: .infinity,
                           alignment: questionCase == .toMe ? .leading : .trailing)
            }
            .frame(height: 5)
            
            Rectangle().fill(Color(.systemGray5)).frame(height: 1)
        }
    }
}

struct CardButtonStyle: ButtonStyle {
    
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption.weight(.semibold))
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(color)
            )
            .scaleEffect(configuration.isPressed ? 0.92: 1)
            .animation(.spring(), value: configuration.isPressed)
    }
}

//Text("더미 데이터 초기화")
//    .font(.footnote)
//    .foregroundColor(.red)
//    .frame(maxWidth: .infinity, alignment: .trailing)
//    .onTapGesture {
//        Storage.remove("userQuestions.json", from: .documents)
//        vm.getQuestions()
//    }

