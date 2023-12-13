//
//  MJKBusinessCardView.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/6/26.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKBusinessCardView : UIView
/** 姓名*/
@property (nonatomic, strong) NSString *nameStr;
/** 职位*/
@property (nonatomic, strong) NSString *positionStr;
/** 电话*/
@property (nonatomic, strong) NSString *phoneStr;
/** 公司*/
@property (nonatomic, strong) NSString *secondStr;
/** 地址*/
@property (nonatomic, strong) NSString *addressStr;
@end

NS_ASSUME_NONNULL_END
