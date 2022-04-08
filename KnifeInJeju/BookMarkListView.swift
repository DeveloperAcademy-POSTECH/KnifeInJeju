//
//  BookMarkListView.swift
//  KnifeInJeju
//
//  Created by 김예훈 on 2022/04/08.
//

import SwiftUI

class BookMarkListViewModel: ObservableObject {
    @Published var questions: [Question] = []
    
    func getQuestions(mainUser: User) {
        questions = mainUser.bookmarkedQuestions
    }
    
    func saveQuestions() {
        // questions을 순회하며 원본 데이터베이스 파일에 있는 question과 같은 id를 찾으면 직접 변경해주고 다시 저장해줌
        if var data = Storage.retrive(Storage.databaseAllQuestionURL, from: .documents, as: [Question].self) {
            questions.forEach { question in
                if let index = data.firstIndex(of: question) {
                    data[index] = question
                }
            }
            Storage.store(data, to: .documents, as: Storage.databaseAllQuestionURL)
        } else {
            fatalError("Failed Get Database In saveQuestions()")
        }
    }
}

struct BookMarkListView: View {
    
    @StateObject var vm = BookMarkListViewModel()
    @ObservedObject var mainUser: MainUserViewModel
    
    var body: some View {
                .onAppear {
            mainUser.getMainUser()
            vm.getQuestions(mainUser: mainUser.user)
        }
    }
}

//struct BookMarkListView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookMarkListView()
//    }
//}
