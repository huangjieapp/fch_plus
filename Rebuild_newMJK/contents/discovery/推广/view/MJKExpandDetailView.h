//
//  MJKExpandDetailView.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/18.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGCExpandModel;
@class XMGTopicVideoView;
@class XMGTopicPictureView;



typedef void(^PICTUREBLOCK)(NSInteger index, NSString *imgStr);
typedef void(^STARTCLICKBLOCK)(UIButton *btn);NS_ASSUME_NONNULL_BEGIN

@interface MJKExpandDetailView : UIView
/** 视频帖子中间的内容 */
@property (nonatomic, weak) XMGTopicVideoView *videoView;
/** 图片帖子中间的内容 */
@property (nonatomic, weak) XMGTopicPictureView *pictureView;
- (instancetype)initWithFrame:(CGRect)frame andDetailModel:(CGCExpandModel *)model;
@property (nonatomic, copy) PICTUREBLOCK picClick;

@property (nonatomic, copy) STARTCLICKBLOCK startBlock;
@end

NS_ASSUME_NONNULL_END
