//
//  MJKTelephoneRobotProcessSubModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/22.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKTelephoneRobotProcessSubModel : MJKBaseModel
/** 机器人话术*/
@property (nonatomic, strong) NSString *botContent;

@property (nonatomic, strong) NSString *chatContent;
@end

NS_ASSUME_NONNULL_END
