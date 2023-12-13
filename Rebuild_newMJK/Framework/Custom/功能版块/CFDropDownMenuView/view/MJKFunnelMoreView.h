//
//  MJKFunnelMoreView.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/12.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKFunnelMoreView : UIView
/** dataArray*/
@property (nonatomic, strong) NSArray *dataArray;
/** */
@property (nonatomic, copy) void(^backModelArrayBlock)(NSArray *modelArray);
@end
