//
//  ViewController.swift
//  SGRecorder
//
//  Created by BoBo on 16/11/30.
//  Copyright © 2016年 SG. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var audioRecorder: AVAudioRecorder? // 录音
    var audioPlayer: AVAudioPlayer? // 播放
    
    fileprivate var startRecordBt: UIButton = {
        let button: UIButton = UIButton(frame: CGRect(x: 60.0, y: 100.0, width: 200.0, height: 50.0))
        button.setTitle("开始录音", for: UIControlState.normal)
        button.setTitleColor(UIColor.gray, for: UIControlState.selected)
        button.backgroundColor = UIColor.red
        return button
    }()
    
    fileprivate var stopRecordBt: UIButton = {
        let button: UIButton = UIButton(frame: CGRect(x: 60.0, y: 200.0, width: 200.0, height: 50.0))
        button.setTitle("结束录音", for: UIControlState.normal)
        button.setTitleColor(UIColor.gray, for: UIControlState.selected)
        button.backgroundColor = UIColor.red
        return button
    }()
    
    fileprivate var startPlayBt: UIButton = {
        let button: UIButton = UIButton(frame: CGRect(x: 60.0, y: 300.0, width: 200.0, height: 50.0))
        button.setTitle("播放录音", for: UIControlState.normal)
        button.setTitleColor(UIColor.gray, for: UIControlState.selected)
        button.backgroundColor = UIColor.red
        return button
    }()
    
    fileprivate var stopPlayBt: UIButton = {
        let button: UIButton = UIButton(frame: CGRect(x: 60.0, y: 400.0, width: 200.0, height: 50.0))
        button.setTitle("结束播放录音", for: UIControlState.normal)
        button.setTitleColor(UIColor.gray, for: UIControlState.selected)
        button.backgroundColor = UIColor.red
        return button
    }()
    
    fileprivate var transformBt: UIButton = {
        let button: UIButton = UIButton(frame: CGRect(x: 60.0, y: 500.0, width: 200.0, height: 50.0))
        button.setTitle("格式转换", for: UIControlState.normal)
        button.setTitleColor(UIColor.gray, for: UIControlState.selected)
        button.backgroundColor = UIColor.red
        return button
    }()
    
    // 定义音频的编码参数, 决定录制音频文件的格式, 音质, 容量大小等, 建议采用AAC的编码方式
    let recordSettings = [AVSampleRateKey: NSNumber(value: Float(44100.0)), // 声音采样率
                          AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM), // 编码格式
                          AVNumberOfChannelsKey: NSNumber(value: 2), //采集音轨
                          AVEncoderAudioQualityKey: NSNumber(value: Int32(AVAudioQuality.medium.rawValue)), // 音频质量
                          AVLinearPCMBitDepthKey: NSNumber(value: 16),
                          AVLinearPCMIsFloatKey: NSNumber(value: false),
                          AVLinearPCMIsBigEndianKey: NSNumber(value: false)]
    
    fileprivate var mp3Path: String?
    fileprivate var cafPath: String?
    fileprivate var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        creatSession()
    }
    
    func initViews()
    {
        self.view.addSubview(startRecordBt)
        self.view.addSubview(startPlayBt)
        self.view.addSubview(stopRecordBt)
        self.view.addSubview(stopPlayBt)
        self.view.addSubview(transformBt)
        
        startRecordBt.addTarget(self, action: #selector(startRecord), for: UIControlEvents.touchUpInside)
        startPlayBt.addTarget(self, action: #selector(startPlaying), for: UIControlEvents.touchUpInside)
        stopRecordBt.addTarget(self, action: #selector(stopRecord), for: UIControlEvents.touchUpInside)
        stopPlayBt.addTarget(self, action: #selector(playMp3), for: UIControlEvents.touchUpInside)
        transformBt.addTarget(self, action: #selector(toMP3), for: UIControlEvents.touchUpInside)
    }
    
    // 创建会话
    func creatSession()
    {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            if let url: URL = self.directoryURL() {
                try audioRecorder = AVAudioRecorder(url: url, settings: recordSettings) // 初始化实例
            }
            audioRecorder?.prepareToRecord() // 准备录音
        } catch {
            
        }
    }
    
    func directoryURL() -> URL? {
        // 定义并构建一个url来保存音频
        cafPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        mp3Path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        mp3Path?.append("/temp.mp3")
        cafPath?.append("/temp.caf")
        
        return URL(fileURLWithPath: cafPath!)
    }

    // 开始录音
    func startRecord(sender: AnyObject) {
        if let isRecording: Bool = audioRecorder?.isRecording {
            if !isRecording {
                let audioSession = AVAudioSession.sharedInstance()
                do {
                    try audioSession.setActive(true)
                    audioRecorder?.record()
                    print("recordCaf!")
                } catch {
                    
                }
            }
        }
    }
    
    // 停止录音
    func stopRecord(sender: AnyObject)
    {
        audioRecorder?.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
            print("stopCaf!")
        } catch {
            
        }
    }
    
    // 开始播放
    func startPlaying(sender: AnyObject)
    {
        if let isRecording = audioRecorder?.isRecording {
            if (!isRecording)
            {
                do {
                    if let url = audioRecorder?.url {
                        try audioPlayer = AVAudioPlayer(contentsOf: url)
                    }
                    audioPlayer?.play()
                    print("playCaf!")
                } catch {
                    
                }
            }
        }
    }
    
    // 暂停播放
    func pausePlaying(sender: AnyObject)
    {
        if let isRecording = audioRecorder?.isRecording {
            if !isRecording {
                do {
                    if let url = audioRecorder?.url {
                        try audioPlayer = AVAudioPlayer(contentsOf: url)
                    }
                    audioPlayer?.pause()
                    print("pauseCaf")
                } catch {
                    
                }
            }
        }
    }
    
    func toMP3() {
        let audioWrapper: AudioWrapper = AudioWrapper()
        // 本地的.caf文件转换为MP3
//        if let _ = Bundle.main.path(forResource: "output", ofType: "caf") {
//            let localCafPath: String = Bundle.main.path(forResource: "output", ofType: "caf")! // 本地的caf文件
//            audioWrapper.convertSourcem4a(localCafPath, outPutFilePath: mp3Path) { (a:String?) in
//                print("end \(a)");
//            }
//        }
        // 录音.caf文件转换为MP3
        audioWrapper.convertSourcem4a(cafPath, outPutFilePath: mp3Path) { (a:String?) in
            print("end \(a)");
        }
        print(cafPath!)
        print(mp3Path!)
        print("toMp3")
        // 文件位置开头有"/"
        // 手机 "/var/mobile/Containers/Data/Application/7C5E7F18-7C6E-4EEB-8203-08D82A4C2A11/Documents/08122016183666.mp3"
        // 模拟器 "/Users/bobo/Library/Developer/CoreSimulator/Devices/6EA1F730-6939-4FED-8CA9-C733D050C647/data/Containers/Data/Application/AEBA8E5C-058C-4316-B5EE-EE18A437B69D/Documents/temp.mp3"
    }
    
    func playMp3()
    {
        do {
            self.player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: self.mp3Path!), fileTypeHint: "mp3")
        } catch {
            print("出现异常")
        }
        player?.play()
        print("playMp3")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

