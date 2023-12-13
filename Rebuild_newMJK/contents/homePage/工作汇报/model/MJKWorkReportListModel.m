//
//  MJKWorkReportListModel.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/3.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKWorkReportListModel.h"
#import "MJKWorkReportDetailModel.h"
#import "MJKAddMRModel.h"

@implementation MJKWorkReportListModel
+(NSDictionary *)mj_objectClassInArray {
	return @{@"content" : @"MJKWorkReportDetailModel", @"jrjhmx" : @"MJKAddMRModel"};
}

@end
