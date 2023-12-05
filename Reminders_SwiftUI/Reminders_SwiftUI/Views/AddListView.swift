//
//  AddListView.swift
//  Reminders_SwiftUI
//
//  Created by jiyeon on 12/4/23.
//

import SwiftUI

struct AddListView: View {
    @Binding var isPresented: Bool
    @State var listName: String = ""
    @State var selectedColor: Color = .blue
    let palette:[Color] = [.red, .orange, .yellow, .green, .blue, .purple]
    var addList: (ReminderList) -> Void // 클로저 선언
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        HStack {
                            Spacer()
                            Circle()
                                .fill(selectedColor)
                                .shadow(color: selectedColor, radius: 8, x: 0, y: 0)
                                .frame(width: 100)
                                .overlay(
                                    Image(systemName: "list.bullet")
                                        .resizable()
                                        .frame(width: 45, height: 35)
                                        .foregroundColor(.white)
                                )
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                        TextField("List Name", text: $listName)
                            .padding()
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .multilineTextAlignment(.center)
                            .font(.system(.title3, design: .rounded, weight: .bold))
                            .foregroundColor(selectedColor) // 텍스트 색상 변경
                            .background(Color.init(uiColor: .systemGray3)) // 배경색 변경
                            .cornerRadius(10)
                    }
                    Section {
                        HStack(spacing: 10) {
                            ForEach(palette, id: \.self) { color in
                                Circle()
                                    .fill(color)
                                    .frame(width: 40, height: 40)
                                    .onTapGesture {
                                        selectedColor = color
                                    }
                                    .overlay(
                                        Circle()
                                            .stroke(selectedColor == color ? Color.white : Color.clear, lineWidth: 4)
                                    )
                            }
                        }
                    }
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .tertiarySystemBackground))
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {
                        self.isPresented.toggle()
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Done") {
                        let newList = ReminderList(name: listName, color: selectedColor)
                        addList(newList) // 클로저 호출하여 새 리스트 추가
                        self.isPresented.toggle()
                    }
                    .disabled(listName.isEmpty) // listName이 비어있으면 버튼 비활성화
                }
            }
        }
    }
}

#Preview {
    AddListView(isPresented: Binding.constant(true)) { newList in
        print(newList)
    }
}
