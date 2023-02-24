//
//  HomeView.swift
//  HANE24
//
//  Created by Katherine JANG on 2/13/23.
//

import SwiftUI

struct chartItem: Identifiable {
    var id: String
    var title: String
    var period: Array<String>
    var data: Array<Double>
}

var items: [chartItem] = [
    chartItem(id: "주", title: "최근 주간 그래프", period: ["1.2(월)-1.8(일)","1.9(월)-1.15(일)","1.16(월)-1.22(일)","1.23(월)-1.29(일)","1.30(월)-2.5(일)","2.6(월)-2.12(일)"], data:  [42, 20, 41, 33, 59, 50]),
    chartItem(id: "월", title: "최근 월간 그래프", period: ["2023.2","2023.1","2022.12","2022.11","2022.10", "2022.10"], data:  [132, 100, 121, 123, 139, 120])
]

var dailyOptions: Array<Double> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
var monthlyOptions: Array<Double> = [80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240, 250, 260, 270, 280, 290, 300]

struct PullToRefresh: View {
    var coordinateSpaceName: String
    var onRefresh: ()->Void
    
    @State var needRefresh: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName))).midY > 50 {
                Spacer()
                    .onAppear{
                        needRefresh = true
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).midY < 10) {
                Spacer()
                    .onAppear{
                        if needRefresh {
                            needRefresh = false
                            onRefresh()
                        }
                    }
            }
            HStack{
                Spacer()
                if needRefresh {
                    ProgressView()
                }
                Spacer()
            }
        } .padding(.top, -50)
    }
}


struct HomeView: View {
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.gradientPurple)
          UIPageControl.appearance().pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.2)
    }
    @State var test: Bool = true
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var hane: Hane
    @AppStorage("DailySelectionOption") private var dailySelectionOption =  UserDefaults.standard.integer(forKey: "DailySelectionOption")
    @AppStorage("MonthlySelectionOption") private var monthlySelectionOption =  UserDefaults.standard.integer(forKey: "MonthlySelectionOption")

    var body: some View {
        NavigationView{
           ZStack{
               if hane.inOutState {
                   Image("Background")
                        .resizable()
                        .edgesIgnoringSafeArea(.top)
                        .opacity(0.7)
               } else {
                   Theme.BackgoundColor(forScheme: colorScheme)
                       .edgesIgnoringSafeArea(colorScheme == .dark ? .all : .top)
               }
               VStack(alignment: .center, spacing: 20) {
                    HStack(alignment: .center) {
                        AsyncImage(url: URL(string: hane.profileImage)) { image in
                            image
                                .resizable()
                                .frame(width: 28, height: 28)
                                .padding(.trailing, 3)
                                .clipShape(Circle())
                        } placeholder: {
                            Image("cabi")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .padding(.trailing, 3)
                        }
                        
                        Text(hane.loginID)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        
                        if hane.inOutState {
                            Circle()
                                .foregroundColor(.green)
                                .frame(width:8, height: 8)
                                .padding(.bottom, 10)
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: notificationView()) {
                            Image(systemName: "bell")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(test ? .iconColor : .red)
                        }
                        .navigationBarHidden(true)
                        .frame(width: 24, height: 24)
                    }
                    .padding(.top, 20)
                    .frame(height: 30)
                    .padding(.horizontal, 30)
                   
                    ScrollView{
                        PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                            /// [FixMe]
                            Task{
                                try await hane.refresh(date: Date())
                            }
                        }
                        
                        VStack(spacing: 22.5){
                            AccTimeCardView(text: "이용 시간", accTime: hane.dailyAccumulationTime, options: dailyOptions, select: dailySelectionOption) { selection in
                                UserDefaults.standard.setValue(selection, forKey: "DailySelectionOption")
                            }
                                .padding(.horizontal, 30)
                            
                            AccTimeCardView(text: "월 누적 시간", accTime: hane.monthlyAccumulationTime, isColored: true, viewColor: Color(hex: "#735BF2"), options: monthlyOptions, select: monthlySelectionOption) {selection in
                                UserDefaults.standard.setValue(selection, forKey: "MonthlySelectionOption")
                            }
                                .padding(.horizontal, 30)
                            
                            TabView{
                                ChartView(item: items[0])
                                    .padding(.horizontal, 10)
                                ChartView(item: items[1])
                                    .padding(.horizontal, 10)
                            }
                            .padding(.horizontal, 20)
                            .tabViewStyle(.page)
                            .frame(height: 289)
                            
                            PopulationView()
                                .padding(.horizontal, 30)
                        }
                        .padding(.bottom, 30)
                        .padding(.top, 10)
                    } .coordinateSpace(name: "pullToRefresh")
                }
            }
        }
        .navigationTitle("알림")

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(Hane())
    }
}
