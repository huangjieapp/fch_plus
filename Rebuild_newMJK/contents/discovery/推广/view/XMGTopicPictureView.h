//
//  XMGTopicPictureView.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/23.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGCExpandModel;
typedef void(^PICBLOCK)(NSInteger index, NSString *imgStr);

@interface XMGTopicPictureView : UIView
+ (instancetype)pictureView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (nonatomic, strong) CGCExpandModel *expand;

@property (nonatomic, copy) PICBLOCK pBlock;
@end
