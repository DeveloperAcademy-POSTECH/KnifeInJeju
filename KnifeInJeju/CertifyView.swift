//
//  CertifyView.swift
//  KnifeInJeju
//
//  Created by 정지혁 on 2022/04/09.
//

import SwiftUI

struct CertifyView: View {
    var exports: Array<String> = ["Doctor", "Teacher", "lawyer"]
    @State private var selectedExpert = 0
    
    @State var showImagePicker: Bool = false
    @State var image: Image? = nil
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("어떤 전문가인지 선택해주세요.")
                .font(.subheadline)
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .frame(height: 42)
                Picker(selection: $selectedExpert, label: Text("선택")) {
                    ForEach(0 ..< 3) {
                        Text(self.exports[$0])
                    }
                }
            }
            
            Text("첨부 파일을 업로드해주세요.")
                .font(.subheadline)
                .padding(.top, 40)
            
            Text("해당 전문가를 증명할 수 있는 사진을 첨부해주세요.")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .frame(height: 160)
                Button(action: {
                    self.showImagePicker.toggle()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                            .frame(width: 120, height: 120)
                        .padding(20)
                        
                        Image(systemName: "paperclip")
                            .resizable()
                            .foregroundColor(.orange)
                            .frame(width: 30, height: 30)
                        
                        image?.resizable().frame(width: 120, height: 120).cornerRadius(10)
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(sourceType: .photoLibrary) { image in
                            self.image = Image(uiImage: image)
                        }
                    }
                }
            }
            
            Text("제출 시 유의사항\n\n1. 해당 첨부파일은 관리자에게 전송되어 검토 과정을 거치게 됩니다.\n2. 개인정보에 해당하는 내용은 지워서 첨부해주시길 바랍니다.")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 40)
            
            Spacer()
            
            Button(action: {
                // 버튼을 누르면, 작성된 내용이 서버로? 전송됩니다.
                dismiss()
            }) {
                Text("제출하기")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .background(.orange)
            .cornerRadius(10)
        }
        .padding()
        .background(Color(.systemGray6))
        .navigationTitle("전문가 인증")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CertifyView_Previews: PreviewProvider {
    static var previews: some View {
        CertifyView()
            .previewDevice("iPhone 13 Pro Max")
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode)
    private var presentationMode
    
    let sourceType: UIImagePickerController.SourceType
    let onImagePicked: (UIImage) -> Void
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding
        private var presentationMode: PresentationMode
        private let sourceType: UIImagePickerController.SourceType
        private let onImagePicked: (UIImage) -> Void
        
        init(presentationMode: Binding<PresentationMode>, sourceType: UIImagePickerController.SourceType, onImagePicked: @escaping (UIImage) -> Void) {
            _presentationMode = presentationMode
            self.sourceType = sourceType
            self.onImagePicked = onImagePicked
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            onImagePicked(uiImage)
            presentationMode.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, sourceType: sourceType, onImagePicked: onImagePicked)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
