//
//  AudioRecorder.swift
//  sowhat
//
//  Created by a on 2/16/22.
//

import Foundation
import AVFoundation

class AudioRecorder: NSObject, AVAudioRecorderDelegate {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var isAudioRecordingGradient: Bool!
    
    static let shared = AudioRecorder()
    
    private override init() {
        super.init()
        
        checkForRecordingPermission()
    }
    
    func checkForRecordingPermission() {
    
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            
            isAudioRecordingGradient = true
            break
        case .denied:
            isAudioRecordingGradient = false
            break
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { (isAllowed) in
                self.isAudioRecordingGradient = isAllowed
            }
            
        default:
            break
        }
    }
    
    func setupRecorder() {
        
        if isAudioRecordingGradient {
            
            recordingSession = AVAudioSession.sharedInstance()
            
            do {
                try recordingSession.setCategory(.playAndRecord, mode: .default)
                try recordingSession.setActive(true)
            } catch {
                print("error setting up audio recorder", error.localizedDescription)
            }
        }
    }
    
    func startRecording(fileName: String) {
        
        let audioFileName = getDocumentURL().appendingPathComponent(fileName + ".m4a", isDirectory: false)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            print("error recording ", error.localizedDescription)
            finishRecording()
        }
    }
    
    func finishRecording() {
        
        if audioRecorder != nil {
            audioRecorder.stop()
            audioRecorder = nil
        }
    }
    
}
