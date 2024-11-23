//
//  PlayButton.swift
//  Shortcap
//
//  Created by choijunios on 11/14/24.
//

import UIKit

import RxSwift

class PlayButton: UIView {
    
    let tap: PublishSubject<Void> = .init()
    
    override var intrinsicContentSize: CGSize {
        .init(width: 60, height: 35)
    }
    
    private let videoPlayButton: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.image = .init(systemName: "play.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .red
        layer.cornerRadius = 7
        
        self.addSubview(videoPlayButton)
        videoPlayButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            videoPlayButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            videoPlayButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            videoPlayButton.widthAnchor.constraint(equalToConstant: 30),
        ])
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        self.addGestureRecognizer(recognizer)
    }
    required init?(coder: NSCoder) { nil }
    
    @objc
    private func onTap(_ gesture: UITapGestureRecognizer) {
        tap.onNext(())
        
        alpha = 0.5
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }
}
