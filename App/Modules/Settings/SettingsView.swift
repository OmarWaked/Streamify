//
//  SettingsView.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

// MARK: - Import
import SwiftUI

// MARK: - View
struct SettingsView: View {
    var body: some View {
        VStack {
            content
        }
    }
}

// MARK: - Extension
private extension SettingsView {
    var content: some View {
        NavigationView {
            List {
                Section(header: Text("DATA MANAGEMENT")) {
                    NavigationLink(destination: BackupRecoverTransferView()) {
                        HStack {
                            Image(systemName: "arrow.2.circlepath.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.yellow)
                            Text("Backup, Recover, and Transfer")
                                .font(.system(size: 18))
                        }
                    }
                }
                
                Section(header: Text("ACCOUNT")) {
                    NavigationLink(destination: AccountView()) {
                        HStack {
                            Image(systemName: "person.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                            Text("Account")
                                .font(.system(size: 18))
                        }
                    }
                }
                
                Section(header: Text("SUBSCRIPTIONS")) {
                    NavigationLink(destination: RemoveAdsView()) {
                        HStack {
                            Image(systemName: "nosign")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.gray)
                            Text("Remove Ads")
                                .font(.system(size: 18))
                        }
                    }
                }
                
                Section(header: Text("AUDIO")) {
                    NavigationLink(destination: SleepTimerView()) {
                        HStack {
                            Image(systemName: "moon.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.pink)
                            Text("Sleep Timer")
                                .font(.system(size: 18))
                        }
                    }
                }
                
                Section(header: Text("YOUTUBE")) {
                    NavigationLink(destination: YouTubeLoginView()) {
                        HStack {
                            Image(systemName: "play.rectangle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.red)
                            Text("YouTube Login")
                                .font(.system(size: 18))
                        }
                    }
                }
                
                Section(header: Text("SUPPORT")) {
                    NavigationLink(destination: HelpSupportView()) {
                        HStack {
                            Image(systemName: "questionmark.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.green)
                            Text("Help & Support")
                                .font(.system(size: 18))
                        }
                    }
                    NavigationLink(destination: SendFeedbackView()) {
                        HStack {
                            Image(systemName: "paperplane.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.orange)
                            Text("Send Feedback")
                                .font(.system(size: 18))
                        }
                    }
                    NavigationLink(destination: FAQView()) {
                        HStack {
                            Image(systemName: "info.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.purple)
                            Text("FAQ")
                                .font(.system(size: 18))
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
        }
    }
}
