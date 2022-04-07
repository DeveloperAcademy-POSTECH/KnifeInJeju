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
        guard let data = Storage.retrive("mainUser.json", from: .documents, as: User.self) else {
            user = User.dummyMainUserData
            saveMainUser()
            return
        }
        user = data
    }
    
    func saveMainUser() {
        Storage.store(user, to: .documents, as: "mainUser.json")
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
    
    // 백엔드가 있다면 여기서 뷰 모델 생성 시 데이터베이스에 유저 ID 값으로 쿼리를 해서 Question 배열 가져옴
    // but 백엔드가 없으니 로컬에 JSON 파일로 저장한 다음 다시 가져오거나, 로컬에 데이터가 없다면 임시로 더미 데이터 넣어줌.
    init() {
        getQuestions()
    }
    
    func getQuestions() {
        if let data = Storage.retrive("userQuestions.json", from: .documents, as: [Question].self) {
            questions = data
        } else {
            questions = Question.dummyData
            saveQuestions()
        }
    }
    
    func saveQuestions() {
        Storage.store(questions, to: .documents, as: "userQuestions.json")
    }
}

struct LogView: View {
    // 원래는 ContentView에 만들어놓고 environmentObject로 하위 뷰에 주입해줘야 하는 디자인 패턴을 상정하고 코드를 짰으나 협업임으로
    // 건드릴 수 없어 초기화를 여기서 함.
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

        }
        .padding(.horizontal, 17)
        .padding(.top, 20)
    }
    
    private var list: some View {
        ForEach($vm.questions) { $question in
            
            let questionBinding = Binding (
                get: { question },
                set: {
                    question = $0
                    vm.saveQuestions()
                }
            )
            
            if !question.isRejected {
                switch questionCase {
                case .toMe:
                    if question.to.name == mainUser.user.name {
                        if onlyBookMark {
                            if mainUser.checkBookmarked(question) {
                                CardView(question: questionBinding, questionCase: questionCase)
                                    .environmentObject(mainUser)
                            }
                        } else {
                            CardView(question: questionBinding, questionCase: questionCase)
                                .environmentObject(mainUser)
                        }
                    }
                case .toOther:
                    if question.from.name == mainUser.user.name {
                        if onlyBookMark {
                            if mainUser.checkBookmarked(question) {
                                CardView(question: questionBinding, questionCase: questionCase)
                                    .environmentObject(mainUser)
                            }
                        } else {
                            CardView(question: questionBinding, questionCase: questionCase)
                                .environmentObject(mainUser)
                        }
                    }
                }
            }
        }
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}

struct CardView: View {
    @State private var showCardDetailView = false
    @Binding var question: Question
    var questionCase: QuestionCase
    @EnvironmentObject var mainUser: MainUserViewModel
    
    private var bookmarked: Bool {
        mainUser.checkBookmarked(question)
    }
    
    private var hearted: Bool {
        mainUser.checkHearted(question)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            header
            
            tags
            
            main
            
            Divider()
            
            footer
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.background)
        )
        .onTapGesture {
            showCardDetailView = true
        }
        .sheet(isPresented: $showCardDetailView) {
            cardDetail
        }
    }
    
    private var cardDetail: some View {
        VStack(alignment: .leading, spacing: 12) {
            UserHeaderView(user: question.from, date: Date())
            header
            tags
            Divider()
                .padding(.vertical, 4)
            Text(question.text)
                .font(.footnote)
            Divider()
                .padding(.top, 56)
                .padding(.vertical, 4)
            if let answer = question.answer {
                VStack(alignment: .leading) {
                    UserHeaderView(user: question.to, date: question.date)
                    Text(answer.text)
                        .font(.footnote)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(.systemGray6))
                )
                
            }
            
            Spacer()
        }
        .padding(17)
    }
    
    private var header: some View {
        HStack(spacing: 6) {
//            Text("Q.")
            Text(question.title)
                .lineLimit(1)
            
            Spacer()
            
            HStack(spacing: 16) {
                Image(systemName: bookmarked ? "bookmark.fill" : "bookmark")
                    .foregroundColor(bookmarked ? .yellow : .primary)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            if bookmarked {
                                mainUser.removeBookmark(question: question)
                            } else {
                                mainUser.addBookmark(question: question)
                            }
                        }
                    }
                
                HStack {
                    Image(systemName: hearted ? "heart.fill" : "heart")
                    Text("\(question.heartCount)")
                }
                .foregroundColor(hearted ? .red : .primary)
                .onTapGesture {
                    withAnimation(.spring()){
                        if hearted {
                            if mainUser.removeHearted(question: question) {
                                question.heartCount -= 1
                            }
                        } else {
                            mainUser.addHearted(question: question)
                            question.heartCount += 1
                        }
                    }
                }
            }
        }
        .font(.headline.bold())
    }
    
    private var tags: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(question.tags, id: \.self) { tag in
                    TagView(text: tag)
                }
            }
        }
    }
    
    private var main: some View {
        HStack(alignment: .top) {
            Image("")
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(width: 64, height: 64)
                .cornerRadius(12)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray5))
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
                )
            
            Text(question.text)
                .font(.footnote)
                .frame(height: 64)
                .foregroundColor(.gray)
        }
    }
    
    private var footer: some View {
        HStack {
            UserHeaderView(user: questionCase == .toMe ? question.from : question.to, date: question.date)
            
            Spacer()
            
            if questionCase == .toOther {
                Button {
                    withAnimation(.spring()) {
                        
                    }
                } label: {
                    Text("취소하기")
                }
                .buttonStyle(CardButtonStyle(color: Color(.systemGray6)))
            } else if question.answer != nil {
                Button {
                    showCardDetailView = true
                } label: {
                    Label("답변 완료", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.orange)
                        .font(.headline.bold())
                }
                .buttonStyle(.plain)
            } else {
                Button {
                    withAnimation(.spring()) {
                        question.isRejected = true
                    }
                } label: {
                    Text("거절하기")
                }
                .buttonStyle(CardButtonStyle(color: Color(.systemGray6)))
                
                Button {
                    print("답변")
                } label: {
                    Text("답변하기")
                        .foregroundColor(.white)
                }
                .buttonStyle(CardButtonStyle(color: .orange))
            }
        }
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
    case toOther
    
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
                            questionCase = .toOther
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

/*
 CardView(title: "미술 입시 어떻게 하셨어요?",
          text: "저는 미술을 꿈꾸고 있는 중학교 2학년이에요!. 지방에 거주하고 있는지라 미술관련 정보를 얻기 힘들고 대다수가 수도권에 있는 친구들에게 해당할 법한 이야기라 공감하기가 쉽지 않네요.. ",
          isBookmarked: .constant(false),
          isHearted: .constant(false),
          isAnswered: .constant(false),
          tags: ["study", "game"],
          userName: "Yaehoon Kim",
          userPictureName: "")
*/


//Text("더미 데이터 초기화")
//    .font(.footnote)
//    .foregroundColor(.red)
//    .frame(maxWidth: .infinity, alignment: .trailing)
//    .onTapGesture {
//        Storage.remove("userQuestions.json", from: .documents)
//        vm.getQuestions()
//    }

