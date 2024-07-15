//
//  SettingsSubTabs.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

import SwiftUI
import MessageUI

struct AccountView: View {
    var body: some View {
        Text("Account Settings")
            .font(.title2)
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct HelpSupportView: View {
    var body: some View {
        Text("Help & Support")
            .font(.title2)
            .navigationTitle("Help & Support")
            .navigationBarTitleDisplayMode(.inline)
    }
}


struct FAQView: View {
    var body: some View {
        Text("FAQ")
            .font(.title2)
            .navigationTitle("FAQ")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct SleepTimerView: View {
    var body: some View {
        Text("Sleep Timer")
            .font(.title2)
            .navigationTitle("Sleep Timer")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct YouTubeLoginView: View {
    var body: some View {
        Text("YouTube Login")
            .font(.title2)
            .navigationTitle("YouTube Login")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct BackupRecoverTransferView: View {
    var body: some View {
        Text("Backup, Recover, and Transfer")
            .font(.title2)
            .navigationTitle("Backup, Recover, and Transfer")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct RemoveAdsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Button(action: {
                    // Add functionality to remove ads forever
                }) {
                    Text("Remove Ads Forever")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.Tangerine)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    // Add functionality to remove ads for 1 year
                }) {
                    Text("Remove Ads for 1 Year")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.Tangerine)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    // Add functionality to refer 5 friends
                }) {
                    Text("Refer 5 Friends to Get Ads Free")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.Tangerine)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    // Add functionality to recover purchase
                }) {
                    Text("Recover Purchase")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.Tangerine)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("Remove Ads")
        .navigationBarTitleDisplayMode(.inline)
    }
}
