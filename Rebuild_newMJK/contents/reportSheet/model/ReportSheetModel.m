//
//  ReportSheetModel.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/10.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "ReportSheetModel.h"
#import "MJKBFBListModel.h"

@implementation ReportSheetModel
+ (NSDictionary *)mj_objectClassInArray {
	return @{@"BFB_LIST" : @"MJKBFBListModel", @"bfbList" : @"MJKBFBListModel"};
}
@end
