//
//  LogView.swift
//  KnifeInJeju
//
//  Created by 김예훈 on 2022/04/06.
//

import SwiftUI

class LogViewModel: ObservableObject {
    
    @Published var answeredQuestions: [Question] = []
    @Published var unansweredQuestions: [Question] = []
    @Published var questionCase: QuestionCase = .toMe
    @Published var showBookmarked = false
    
    func getQuestions(user: User) {
        // 백엔드 데이터베이스 역할을 할 data 변수 ( 로컬에 json 파일로 저장되어 있음)
        if let data = Storage.retrive(Storage.databaseAllQuestionURL, from: .documents, as: [Question].self) {
            
            // 쿼리역할을 해줄 내부 로직 ( LogView(질문 보관함)은 내(LoginUser)가 받은, 보낸 질문 중 하나를 세그먼트 컨트롤으로
            // 선택해서 해당 요소만 가져오길 원함.
            var answered: [Question] = []
            var unanswered: [Question] = []
            var questions: [Question] = []
            
            switch questionCase {
            case .toMe:
                questions = data.filter{ $0.to.id == user.id }
            case .byMe:
                questions = data.filter{ $0.from.id == user.id }
            case .other:
                fatalError("Failed by Wrong QuestionCase in getQuestions(case:loginUser:)")
            }
            
            questions.forEach { question in
                if question.isAnswered {
                    answered.append(question)
                } else {
                    unanswered.append(question)
                }
            }
            
            answeredQuestions = answered
            unansweredQuestions = unanswered
            
        } else {
            // 저장되어 있는 게 없으면 더미 데이터 저장하고 다시 getQuestion 불러옴, 재귀 무한루프 안빠지게 주의
            Storage.store(Question.dummyData, to: .documents, as: Storage.databaseAllQuestionURL)
            getQuestions(user: user)
        }
    }
    
    func saveQuestions(user: User) {
        // questions을 순회하며 원본 데이터베이스 파일에 있는 question과 같은 id를 찾으면 직접 변경해주고 다시 저장해줌
        if var data = Storage.retrive(Storage.databaseAllQuestionURL, from: .documents, as: [Question].self) {
            let allQuestions = answeredQuestions + unansweredQuestions
            
            allQuestions.forEach { question in
                if let index = data.firstIndex(where: {$0.id == question.id }) {
                    data[index] = question
                    
                    if question.isRejected, question.from == user {
                        data.remove(at: index)
                    }
                }
            }
            
            Storage.store(data, to: .documents, as: Storage.databaseAllQuestionURL)
            getQuestions(user: user)
        } else {
            fatalError("Failed Get Database In saveQuestions()")
        }

    }
    
}

struct LogView: View {
    @EnvironmentObject var loginUserVM: LoginUserViewModel
    @StateObject var vm = LogViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                titleHeader
                
                CustomPicker(questionCase: $vm.questionCase)
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
        .onChange(of: vm.questionCase) { newValue in
            withAnimation(.spring()) {
                vm.getQuestions(user: loginUserVM.user)
            }
        }
        .onAppear{
            loginUserVM.getLoginUser()
            vm.getQuestions(user: loginUserVM.user)
        }
    }
    
    private var titleHeader: some View {
        HStack {
            Text("보관함")
                .font(.title2.weight(.bold))
            Spacer()
            
            HStack {
                Image(systemName: vm.showBookmarked ? "bookmark.fill" : "bookmark")
                    .foregroundColor(vm.showBookmarked ? .yellow : .primary)
                Text("북마크 모아보기")
            }
            .font(.footnote.weight(.semibold))
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.orange.opacity(0.1))
            )
            .onTapGesture {
                withAnimation(.spring()) {
                    vm.showBookmarked.toggle()
                }
            }
            .sheet(isPresented: $vm.showBookmarked, onDismiss: {vm.getQuestions(user: loginUserVM.user)} ) {
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
                
                HStack {
                    Spacer()
                    
                    Button {
                        vm.showBookmarked = false
                    } label: {
                        Text("취소")
                            .font(.headline)
                            .foregroundColor(.orange)
                    }
                }
                
                Text("북마크한 질문 \(loginUserVM.user.bookmarkedQuestions.count)개")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                
                ForEach($loginUserVM.user.bookmarkedQuestions) { $question in
                    CardView(question: $question, loginUserVM: loginUserVM) {
                        vm.saveQuestions(user: loginUserVM.user)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 17)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6))
        .onAppear {
            loginUserVM.getLoginUser()
        }
    }
    
    private var list: some View {
        Group {
            ForEach($vm.unansweredQuestions) { $question in
                if !question.isRejected {
                    CardView(question: $question, loginUserVM: loginUserVM) {
                        vm.saveQuestions(user: loginUserVM.user)
                    }
                }
            }
            
            Capsule()
                .fill(.background)
                .frame(maxWidth: .infinity).frame(height: 2)
                .padding(.vertical, 4)
            
            ForEach($vm.answeredQuestions) { $question in
                if !question.isRejected {
                    CardView(question: $question, loginUserVM: loginUserVM) {
                        vm.saveQuestions(user: loginUserVM.user)
                    }
                }
            }
        }
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
                        withAnimation(.expo) {
                            questionCase = .toMe
                        }
                    }
                Text("보낸 질문")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.expo) {
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

extension Animation {
    static let expo: Animation = .timingCurve(0.16, 1, 0.3, 1)
}

//struct LogView_Previews: PreviewProvider {
//    static var previews: some View {
//        LogView()
//            .environmentObject(LoginUserViewModel())
//    }
//}
