//
//  ExpandCell.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/23.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMGTopicVideoView;
@class XMGTopicPictureView;

typedef void(^PICTUREBLOCK)(NSInteger index, NSString *imgStr);
typedef void(^STARTCLICKBLOCK)(UIButton *btn);

@class CGCExpandModel;

@interface ExpandCell : UITableViewCell


/** 视频帖子中间的内容 */
@property (nonatomic, weak) XMGTopicVideoView *videoView;
/** 图片帖子中间的内容 */
@property (nonatomic, weak) XMGTopicPictureView *pictureView;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *titLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UILabel *desLab;


@property (nonatomic, strong) CGCExpandModel *expand;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, copy) PICTUREBLOCK picClick;

@property (nonatomic, copy) STARTCLICKBLOCK startBlock;


@end
