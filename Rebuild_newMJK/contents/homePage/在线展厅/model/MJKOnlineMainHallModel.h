//
//  MJKOnlineMainHallModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/19.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKOnlineMainHallModel : NSObject
@property (nonatomic, strong) NSString *C_TOKEN;//萤石
@property (nonatomic, strong) NSString *C_YSAPPKEY;
@property (nonatomic, strong) NSString *C_YSSECRET;
@property (nonatomic, strong) NSArray *content;
@end
