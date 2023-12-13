//
//  MJKBaseModel.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2023/3/30.
//  Copyright © 2023 脉居客. All rights reserved.
//

#import "MJKBaseModel.h"
#import "NSString+Extern.h"

@implementation MJKBaseModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([NSString isEmpty:oldValue]) {// 以字符串类型为例
    return @"";
    }
    return oldValue;
}
@end
