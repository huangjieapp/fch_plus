//
//  MJKCommentsListModel.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/4.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKCommentsListModel.h"
#import "MJKTaskCommentModel.h"

@implementation MJKCommentsFileListModel



@end

@implementation MJKCommentsListModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"hf_list" : @"MJKTaskCommentModel",
             @"replyList" : @"MJKCommentsListModel",
             @"fileList" : @"MJKCommentsFileListModel"
    };
}


@end

