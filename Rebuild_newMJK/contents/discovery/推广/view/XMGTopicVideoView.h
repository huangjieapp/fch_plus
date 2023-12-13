//
//  XMGTopicVideoView.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/23.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CGCExpandModel;
typedef void(^STARTBLOCK)(UIButton *btn);
@interface XMGTopicVideoView : UIView

+ (instancetype)videoView;
@property (weak, nonatomic) IBOutlet UIButton *mareButton;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (nonatomic, strong) CGCExpandModel *expand;

@property (nonatomic, copy) STARTBLOCK sBlock;

@end
