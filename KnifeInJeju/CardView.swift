//
//  CardView.swift
//  KnifeInJeju
//
//  Created by 김예훈 on 2022/04/07.
//

import SwiftUI

// 카드뷰 변경된 디자인에 따라 리팩토링 작업 중..

struct CardView: View {
    @State private var showCardDetailView = false
    
    @Binding var question: Question
    @ObservedObject var mainUser: MainUserViewModel
    
    private var questionCase: QuestionCase {
        if mainUser.user.id == question.to.id {
            return .toMe
        } else if mainUser.user.id == question.from.id {
            return .byMe
        } else {
            return .other
        }
    }
    
    private var bookmarked: Bool {
        mainUser.checkBookmarked(question)
    }
    
    private var hearted: Bool {
        mainUser.checkHearted(question)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            header()
            
            main
            
            Divider()
            
            footer
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.background)
        )
        .opacity(question.isAnswered && questionCase == .toMe ? 0.6 : 1)
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
            
            HStack {
                header(font: .headline.bold())
                
                Spacer()
                
                bookmarkButton
                
                heartButton
            }
            
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
                    Text(answer)
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
    
    private func header(font: Font = .subheadline) -> some View {
        HStack(spacing: 6) {
            Text("Q.")
            Text(question.title)
                .lineLimit(1)
            
            Spacer()
        }
        .font(font)
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
        Text(question.text)
            .font(.caption)
            .frame(height: 64)
            .foregroundColor(.gray)
    }
    
    private var footer: some View {
        HStack {
            UserHeaderView(user: questionCase == .toMe ? question.from : question.to, date: question.date)
            
            Spacer()
            
            if question.isAnswered {
                if questionCase == .byMe {
                    
                    bookmarkButton
                    
                    heartButton
                    
                } else if questionCase == .toMe {
                    
                    answeredLabel
                    
                } else if questionCase == .other {
                    
                    bookmarkButton
                    
                    heartButton
                    
                }
            } else {
                if questionCase == .byMe {
                    
                    cancelButton
                    
                } else if questionCase == .toMe {
                    
                    rejectButton
                    
                    answerButton
                    
                }
            }
        }
    }
    
    private var answeredLabel: some View {
        Button {
            showCardDetailView = true
        } label: {
            Label("답변 완료", systemImage: "checkmark.circle.fill")
                .foregroundColor(.orange)
                .font(.headline.bold())
        }
        .buttonStyle(.plain)
    }
    
    private var answerButton: some View {
        Button {
            print("답변")
        } label: {
            Text("답변하기")
                .foregroundColor(.white)
        }
        .buttonStyle(CardButtonStyle(color: .orange))
    }
    
    private var rejectButton: some View {
        Button {
            withAnimation(.spring()) {
                question.isRejected = true
            }
        } label: {
            Text("거절하기")
        }
        .buttonStyle(CardButtonStyle(color: Color(.systemGray6)))
    }
    
    private var cancelButton: some View {
        Button {
            withAnimation(.spring()) {
                print("질문 취소하는 코드")
            }
        } label: {
            Text("취소하기")
        }
        .buttonStyle(CardButtonStyle(color: Color(.systemGray6)))
    }
    
    private var bookmarkButton: some View {
        Image(systemName: bookmarked ? "bookmark.fill" : "bookmark")
            .padding(.horizontal, 2)
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
    }
    
    private var heartButton: some View {
        HStack {
            Image(systemName: hearted ? "heart.fill" : "heart")
                .padding(.horizontal, 2)
//            Text("\(question.heartCount)")
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

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
//}
