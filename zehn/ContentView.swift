//
//  ContentView.swift
//  zehn
//
//  Created by Nikhilkumar Jadhav on 8/25/23.
//

import SwiftUI
import CoreData
import AVFoundation
import Speech

struct ContentView: View {
    @State private var isRecording: Bool = false
    @State private var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()


    var body: some View {
        VStack(spacing: 20) {
            Circle()
                .frame(width: 100, height: 100)
                .foregroundColor(isRecording ? Color.red : Color.green)
                .overlay(
                    Text(isRecording ? "Stop" : "Start")
                        .foregroundColor(.white)
                        .font(.title2)
                )
                .onTapGesture {
                    // Toggle recording state
                    self.isRecording.toggle()

                    // You can call your recording function here
                    if self.isRecording {
                        startRecording()
                    } else {
                        stopRecording()
                    }
                }

            Text(isRecording ? "Recording..." : "Tap to start recording")
                .font(.title3)
        }
    }

    func startRecording() {
        // Cancel the previous task if it's running.
        recognitionTask?.cancel()
        self.recognitionTask = nil
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to set up audio session: \(error)")
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request) { result, error in
            if let transcription = result?.bestTranscription {
                print(transcription.formattedString)
            }
        }
        
        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Could not start audio engine: \(error)")
            return
        }
    }

    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request.endAudio()
        
        recognitionTask?.cancel()
        recognitionTask = nil
    }

}
