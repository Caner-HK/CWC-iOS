//
//  CanerWeatherApp.swift
//  CanerWeather
//
//  Created by Kent Ye (Caner Developer Team) on 2024/1/21.
//
import SwiftUI
import AVFoundation



struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var showingAlert = false
    private var audioPlayerManager = AudioPlayerManager()

    var body: some View {
        TabView {
            // 如果有定位数据，则显示带有定位参数的WebView
            if let location = locationManager.currentLocation {
                WebView(url: URL(string: "https://weather.caner.hk/?location=\(location.latitude),\(location.longitude)")!)
                    .tabItem {
                        Image(systemName: "globe")
                        Text("天气")
                    }
            } else {
                // 如果没有定位数据，则显示默认的WebView
                WebView(url: URL(string: "https://weather.caner.hk")!)
                    .tabItem {
                        Image(systemName: "globe")
                        Text("天气")
                    }
                    .onAppear {
                        // 如果定位服务被拒绝，则显示弹窗
                        if locationManager.isLocationServiceDenied {
                            showingAlert = true
                        }
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("提示"), message: Text("💦您没有授予位置信息权限，我们将通过您的IP地址自动判断您的位置。您可以前往设置重新开启定位权限。"), dismissButton: .default(Text("好的😅")))
                    }
            }
            
            // “我的”页面的视图
            VStack {
                Spacer().frame(height: 20) // 顶部留白
                
                // 账号显示区域
                HStack {
                    Image("canerhklogo1") // 使用你的头像图片名称
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60) // 设定头像大小
                        //.clipShape(Circle())  使头像显示为圆形
                    
                    Text("Caner HK")
                        .font(.title) // 大号字体
                        .fontWeight(.medium) // 字体粗细
                    
                    Spacer() // 使头像和文字靠左对齐
                }
                .padding(.horizontal) // 为HStack添加水平内边距
                .padding(.leading, 22) // 增加左侧内边距使头像和文字不那么靠近左边
                Spacer() // 使用Spacer来推送内容到页面中间
                
                Button(action: {
                    // 用户点击按钮时播放音频
                    audioPlayerManager.playSound(soundFileName: "canerhkthank") // 替换为你的音频文件名，不包括扩展名
                }) {
                    Text("感谢使用Caner Weather Channel")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
                
                Spacer() // 再次使用Spacer来平衡空间
                
                // 版权信息和构建信息
                VStack {
                    Text("© Caner HK 2024 - All Rights Reserved.")
                        .font(.footnote)
                    Text("This is a preview version of CWC iOS App.")
                        .font(.footnote)
                    Text("Version 0.0.2-Pre. Build by Kent Ye.")
                        .font(.footnote)
                }
                .padding() // 添加一些内边距
                
                Spacer().frame(height: 20) // 底部留白
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("我的")
            }
        }
    }
}
