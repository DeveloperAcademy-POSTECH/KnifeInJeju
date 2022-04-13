//
//  BookmarkListView.swift
//  KnifeInJeju
//
//  Created by 김예훈 on 2022/04/12.
//

import SwiftUI

class BookmarkViewModel: ObservableObject {
    @Published var bookmarkedQuestions: [Question] = []
    
    func getQuestions(loginUserVM: LoginUserViewModel) {
        if let data = Storage.retrive(Storage.databaseAllQuestionURL, from: .documents, as: [Question].self) {
            data.forEach { question in
                if let index = loginUserVM.user.bookmarkedQuestions.firstIndex(where: {$0.id == question.id}) {
                    loginUserVM.user.bookmarkedQuestions[index] = question
                }
            }
        }
        loginUserVM.saveLoginUser()
        bookmarkedQuestions = loginUserVM.user.bookmarkedQuestions
    }
    
    func saveQuestions(loginUserVM: LoginUserViewModel) {
        if var data = Storage.retrive(Storage.databaseAllQuestionURL, from: .documents, as: [Question].self) {
            bookmarkedQuestions.forEach { question in
                if let index = data.firstIndex(where: {$0.id == question.id}) {
                    data[index] = question
                }
            }

            Storage.store(data, to: .documents, as: Storage.databaseAllQuestionURL)
        }
        
        if var data = Storage.retrive(Storage.loginUserURL, from: .documents, as: User.self) {
            data.bookmarkedQuestions = bookmarkedQuestions
            Storage.store(data, to: .documents, as: Storage.loginUserURL)
        }
        
        loginUserVM.getLoginUser()
        getQuestions(loginUserVM: loginUserVM)
    }
}

struct BookmarkListView: View {
    
    @StateObject var vm = BookmarkViewModel()
    @ObservedObject var loginUserVM: LoginUserViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                Capsule()
                    .fill(.gray.opacity(0.5))
                    .frame(width: 60, height: 5)
                    .padding(.top, 10)
                
                HStack {
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("취소")
                            .font(.headline)
                            .foregroundColor(.orange)
                    }
                }
                
                Text("북마크한 질문 \(vm.bookmarkedQuestions.count)개")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                
                ForEach($vm.bookmarkedQuestions) { $question in
                    CardView(question: $question, loginUserVM: loginUserVM) {
                        vm.saveQuestions(loginUserVM: loginUserVM)
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
            vm.getQuestions(loginUserVM: loginUserVM)
        }
    }
}

//struct BookmarkListView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookmarkListView()
//    }
//}
