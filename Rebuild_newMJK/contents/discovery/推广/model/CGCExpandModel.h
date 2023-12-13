//
//  CGCExpandModel.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/23.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGCExpandModel : MJKBaseModel

@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *poster;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSMutableArray *images;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *video;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *accountid;
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *store;
@property (nonatomic, strong) NSString *salesname;
@property (nonatomic, copy) NSString *salespicture;
/** <#注释#>*/
@property (nonatomic, strong) NSString *addressName;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign , readonly) CGRect videoF;
/** 声音控件的frame */
@property (nonatomic, assign, readonly) CGRect pictureF;

@property (nonatomic, assign,getter=is_videoPlaying) BOOL videoPlaying;
@end
