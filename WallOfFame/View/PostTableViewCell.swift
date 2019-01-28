//
//  PostTableViewCell.swift
//  WallOfFame
//
//  Created by Nitish Srivastava on 22/01/19.
//  Copyright © 2019 Nitish Srivastava. All rights reserved.
//

import UIKit
import AlamofireImage
import AVKit
import AVFoundation

class PostTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var postCardView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var userDetailCardView: UIView!
    @IBOutlet weak var userDetailView: UIView!
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var userTopic: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var reactionCollectionView: UICollectionView!

    @IBOutlet weak var giveReactionView: UIView!
    
    @IBOutlet weak var ReactionView: UIView!
    @IBOutlet weak var reactionImage: UIImageView!
    @IBOutlet weak var reactionLabel: UILabel!
    @IBOutlet weak var reactionViewBtn: UIButton!
    
    var reactionClicked = false
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var playerItem:AVPlayerItem?
    
    var playbackSlider: UISlider?
    var playButton:UIButton?
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    var reaction: Reaction?
        
    func play() {
        if player!.isPlaying == false {
            player?.play()
        }
    }
    
    func stopPlayer() {
        if player?.isPlaying == true {
            player?.pause()
            player = nil
        }
        
    }
    
    func pause(){
        if player?.isPlaying == true{
            player?.pause()
        }
    }

    
    @objc func playButtonTapped(_ sender:UIButton)
    {
        if player?.rate == 0
        {
            player!.play()
            playButton!.isHidden = true
        } else {
            player!.pause()
            playButton!.isHidden = false
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        player?.rate = 0
        player?.seek(to: .zero)
        playButton!.isHidden = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        giveReactionView.isHidden = true
        giveReactionView.layer.cornerRadius = self.giveReactionView.bounds.height/2
        giveReactionView.layer.masksToBounds = true
        
        self.reactionCollectionView.delegate = self
        self.reactionCollectionView.dataSource = self
        self.reactionCollectionView.showsHorizontalScrollIndicator = false
        // Initialization code
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (reaction?.getReactionCount())!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = reactionCollectionView.dequeueReusableCell(withReuseIdentifier: "reactions", for: indexPath) as! ReactionCollectionViewCell
        
        let rction = reaction?.getAvailableReaction()
        
        let rctn = rction![indexPath.row]
        
        let imageString = rctn.keys.first!
        let reactionCount = rctn.values.first!
        
        let reactionButton = MIBadgeButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        var _ = reactionButton.initWithFrame(frame: CGRect(x: 0, y: 0, width: 25, height: 25), withBadgeString: "", withBadgeInsets:  UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        let cartBarbuttonImage = UIImage(named: imageString)
        reactionButton.contentMode = .scaleAspectFit
        reactionButton.setImage(cartBarbuttonImage, for: UIControl.State())
        reactionButton.setImage(cartBarbuttonImage, for: .selected)
        reactionButton.badgeString = String(reactionCount)
        
        cell.reactionView.addSubview(reactionButton)
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 30, height: 30)
    }


    override func prepareForReuse() {
        // your cleanup code
        userPic.image = UIImage(named: "placeHolder")
        userName.text = ""
        userTopic.text = ""
        reaction = nil
        videoView.backgroundColor = UIColor.black
        playerLayer?.removeFromSuperlayer()
        playButton?.removeFromSuperview()
        player = nil
        giveReactionView.isHidden = true
        reactionClicked = false
    }
    
    func setViewData(post: Post){
        if let url1 = URL(string: ((post.user?.imageUrl)!)){
            userPic.af_setImage(withURL: url1)
        }else{
            userPic.image = UIImage(named: "placeHolder")
        }
        
        userName.text = "by" + " " + (post.user?.name)!
        userTopic.text = post.name
        reaction = post.reaction
        videoView.backgroundColor = UIColor.black
        
        if let videoURL = URL(string: (post.user?.videoUrl)!){
            playerItem = AVPlayerItem(url: videoURL)
            player = AVPlayer(playerItem: playerItem)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer!.frame = videoView.frame
            videoView.layer.addSublayer(playerLayer!)
            
            playButton = UIButton(type: UIButton.ButtonType.system) as UIButton
            
            playButton!.frame = CGRect(x:0, y:0, width: videoView.bounds.height/3, height:videoView.bounds.height/3)
            playButton?.center = videoView.center
            playButton!.backgroundColor = UIColor.clear
            playButton?.setImage(UIImage(named: "play-button"), for: UIControl.State.normal)
            playButton!.tintColor = UIColor.white
            playButton!.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
            
            videoView.addSubview(playButton!)
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
            
          
        }
        
    }
    
    
    @IBAction func onReactionViewClick(_ sender: Any) {
        
        if !(reactionClicked){
            giveReactionView.isHidden = false
            reactionClicked = true
        }else{
            giveReactionView.isHidden = true
            reactionClicked = false
        }
        
    }
    
}
