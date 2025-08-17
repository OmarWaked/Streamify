//
//  AudioModel.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

import Foundation
import SwiftUI
import AVFoundation
import MediaPlayer

// MARK: - Audio Models
struct AudioTrack: Identifiable, Codable {
    let id: String
    let title: String
    let artist: String
    let album: String?
    let duration: TimeInterval
    let artworkURL: String?
    let audioURL: String?
    let genre: String?
    let releaseYear: Int?
    
    init(id: String, title: String, artist: String, album: String? = nil, duration: TimeInterval, artworkURL: String? = nil, audioURL: String? = nil, genre: String? = nil, releaseYear: Int? = nil) {
        self.id = id
        self.title = title
        self.artist = artist
        self.album = album
        self.duration = duration
        self.artworkURL = artworkURL
        self.audioURL = audioURL
        self.genre = genre
        self.releaseYear = releaseYear
    }
}

struct AudioPlaylist: Identifiable, Codable {
    let id: UUID
    var name: String
    var tracks: [AudioTrack]
    var isPublic: Bool
    var createdAt: Date
    var artworkURL: String?
    
    init(id: UUID = UUID(), name: String, tracks: [AudioTrack] = [], isPublic: Bool = true, createdAt: Date = Date(), artworkURL: String? = nil) {
        self.id = id
        self.name = name
        self.tracks = tracks
        self.isPublic = isPublic
        self.createdAt = createdAt
        self.artworkURL = artworkURL
    }
}

// MARK: - Audio Player State
enum AudioPlayerState {
    case stopped
    case playing
    case paused
    case buffering
    case error(String)
}

// MARK: - Audio Player View
struct AudioPlayerView: View {
    let track: AudioTrack
    @StateObject private var audioManager = AudioManager()
    
    var body: some View {
        VStack(spacing: 20) {
            // Artwork
            AsyncImage(url: URL(string: track.artworkURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "music.note")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                    )
            }
            .frame(width: 250, height: 250)
            .clipped()
            .cornerRadius(20)
            .shadow(radius: 10)
            
            // Track Info
            VStack(spacing: 8) {
                Text(track.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(track.artist)
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                if let album = track.album {
                    Text(album)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)
            
            // Progress Bar
            VStack(spacing: 8) {
                ProgressView(value: audioManager.currentTime, total: track.duration)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                
                HStack {
                    Text(formatTime(audioManager.currentTime))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(formatTime(track.duration))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)
            
            // Controls
            HStack(spacing: 30) {
                Button(action: audioManager.previousTrack) {
                    Image(systemName: "backward.fill")
                        .font(.title)
                        .foregroundColor(.primary)
                }
                
                Button(action: audioManager.togglePlayPause) {
                    Image(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                }
                
                Button(action: audioManager.nextTrack) {
                    Image(systemName: "forward.fill")
                        .font(.title)
                        .foregroundColor(.primary)
                }
            }
            
            // Additional Controls
            HStack(spacing: 40) {
                Button(action: audioManager.toggleShuffle) {
                    Image(systemName: audioManager.isShuffled ? "shuffle" : "shuffle")
                        .font(.title2)
                        .foregroundColor(audioManager.isShuffled ? .blue : .primary)
                }
                
                Button(action: audioManager.toggleRepeat) {
                    Image(systemName: audioManager.repeatMode.iconName)
                        .font(.title2)
                        .foregroundColor(audioManager.repeatMode == .none ? .primary : .blue)
                }
                
                Button(action: audioManager.toggleFavorite) {
                    Image(systemName: audioManager.isFavorite ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(audioManager.isFavorite ? .red : .primary)
                }
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            audioManager.setupAudioSession()
            audioManager.loadTrack(track)
        }
        .onDisappear {
            audioManager.cleanup()
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Audio Manager
class AudioManager: ObservableObject {
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var isShuffled = false
    @Published var repeatMode: RepeatMode = .none
    @Published var isFavorite = false
    
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    private var currentTrack: AudioTrack?
    
    enum RepeatMode {
        case none, one, all
        
        var iconName: String {
            switch self {
            case .none: return "repeat"
            case .one: return "repeat.1"
            case .all: return "repeat"
            }
        }
    }
    
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    func loadTrack(_ track: AudioTrack) {
        currentTrack = track
        
        // For demo purposes, we'll use a sample audio file
        // In production, you'd load the actual audio URL
        guard let url = URL(string: "https://www.soundjay.com/misc/sounds/bell-ringing-05.wav") else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            startTimer()
        } catch {
            print("Failed to load audio: \(error)")
        }
    }
    
    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func play() {
        audioPlayer?.play()
        isPlaying = true
        startTimer()
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        stopTimer()
    }
    
    func stop() {
        audioPlayer?.stop()
        isPlaying = false
        currentTime = 0
        stopTimer()
    }
    
    func nextTrack() {
        // Implement next track logic
    }
    
    func previousTrack() {
        // Implement previous track logic
    }
    
    func toggleShuffle() {
        isShuffled.toggle()
    }
    
    func toggleRepeat() {
        switch repeatMode {
        case .none: repeatMode = .all
        case .all: repeatMode = .one
        case .one: repeatMode = .none
        }
    }
    
    func toggleFavorite() {
        isFavorite.toggle()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.audioPlayer else { return }
            self.currentTime = player.currentTime
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func cleanup() {
        stop()
        audioPlayer = nil
    }
}

// MARK: - AVAudioPlayerDelegate
extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        currentTime = 0
        
        switch repeatMode {
        case .one:
            play()
        case .all:
            nextTrack()
        case .none:
            break
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        isPlaying = false
        print("Audio decode error: \(error?.localizedDescription ?? "Unknown error")")
    }
}

// MARK: - Audio List Item
struct AudioListItemView: View {
    let track: AudioTrack
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: track.artworkURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "music.note")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        )
                }
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(track.title)
                        .font(.headline)
                        .lineLimit(1)
                        .foregroundColor(.primary)
                    
                    Text(track.artist)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Text(formatTime(track.duration))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Audio Grid Item
struct AudioGridItemView: View {
    let track: AudioTrack
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                AsyncImage(url: URL(string: track.artworkURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "music.note")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        )
                }
                .frame(height: 120)
                .clipped()
                .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(track.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .foregroundColor(.primary)
                    
                    Text(track.artist)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
