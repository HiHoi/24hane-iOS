//
//  TagLogView.swift
//  HANE24
//
//  Created by Yunki on 2023/02/16.
//

import SwiftUI

struct TagLogView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedDate: Date
    var logList: [Log]
    
    var body: some View {
        VStack(alignment:.center, spacing: 4) {
            HStack{
                Text("\(selectedDate.monthToInt).\(selectedDate.dayToInt) 일요일")
//                    .frame(width: 59, height: 24)
                    .padding(.leading, 18)
                Spacer()
                Text("\(7)시간 \(48)분")
//                    .frame(width: 59, height: 24)
                    .padding(.trailing, 8)
            }
            .font(.system(size: 14, weight: .medium, design: .default))
            .foregroundColor(Color.gray)
//            .padding(.horizontal, 10)
            
            
            Divider()
                .padding(.bottom, 2)
            
            HStack {
                Text("입실")
                    .frame(width: 65, height: 24)
                
                Spacer()
                
                Text("퇴실")
                    .frame(width: 65, height: 24)
                
                Spacer()
                
                Text("체류시간")
                    .frame(width: 65, height: 24)
            }
            .foregroundColor(colorScheme == .dark ? .white : .DarkDefaultBG)
            .font(.system(size: 14, weight: .bold))
            
            if logList.isEmpty {
                Text("기록이 없습니다.")
                    .foregroundColor(colorScheme == .light ? .chartDetailBG : .white)
                    .font(.system(size: 13, weight: .light))
                    .padding(.vertical, 5)
            } else {
                ScrollView {
                    ForEach(logList, id: \.self) { log in
//                        if let log = log {
                            tagLog(log)
//                        } else {
//
//                        }
                    }
                }
            }
            
            
        }
        
    }
    
    @ViewBuilder
    func tagLog(_ log: Log) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(colorScheme == .dark ? Color(hex: "555555") : Color(hex: "#EAEAEA"))
                .frame(height: 24)
                .isHidden((log.logTime ?? "-") != "누락")
            
            HStack {
                Text(log.inTime ?? "-")
                    .frame(width: 65, height: 24)
                
                Spacer()
                
                Text(log.outTime ?? "-")
                    .frame(width: 65, height: 24)
                
                Spacer()
                
                Text(log.logTime ?? "-")
                    .frame(width: 65, height: 24)
            }
            .font(.system(size: 14, weight: .regular))
        }
    }
}

struct TagLogView_Previews: PreviewProvider {
    static var previews: some View {
        TagLogView(selectedDate: .constant(Date()), logList: [])
    }
}
