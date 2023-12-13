//
//  MJKClueDetailModel.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/8/30.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "MJKClueDetailModel.h"

@implementation MJKClueDetailModel
+ (NSArray *)arrayWithModel:(MJKClueDetailModel *)model {
    NSString *ownerName = model.C_OWNER_ROLENAME;
    if ([ownerName containsString:@"/"]) {
        NSRange range = [ownerName rangeOfString:@"/"];
        ownerName = [ownerName substringToIndex:range.location];
    }
	NSArray *array = [NSArray arrayWithObjects:
                      model.C_TYPE_DD_NAME.length > 0 ? model.C_TYPE_DD_NAME : @"",
					  model.C_NAME.length > 0 ? model.C_NAME : @"",
					  model.C_PHONE.length > 0 ? model.C_PHONE : @"",
					  model.C_WECHAT.length > 0 ? model.C_WECHAT : @"",
					  model.C_ADDRESS.length > 0 ? model.C_ADDRESS : @"",
					  model.C_PURPOSE.length > 0 ? model.C_PURPOSE : @"",
					  model.C_SEX_DD_NAME.length > 0 ? model.C_SEX_DD_NAME : @"",
                      model.intentionDesc.length > 0 ? model.intentionDesc : @"",
                      
                      model.C_ENGLISHNAME.length > 0 ? model.C_ENGLISHNAME : @"",
                      
					  model.C_CLUESOURCE_DD_NAME.length > 0 ? model.C_CLUESOURCE_DD_NAME : @"",
					  model.C_A41200_C_NAME.length > 0 ? model.C_A41200_C_NAME : @"",
                      model.C_A47700_C_NAME > 0 ? model.C_A47700_C_NAME : @"",
                      model.C_CLUEPROVIDER_ROLENAME > 0 ? model.C_CLUEPROVIDER_ROLENAME : @"",
                      model.C_SOURCEOWNERNAME > 0 ? model.C_SOURCEOWNERNAME : @"",
					  ownerName.length > 0 ? ownerName : @"",
					  model.C_CREATOR_ROLENNAME.length > 0 ? model.C_CREATOR_ROLENNAME : @"",/*
					  model.D_SHOP_TIME.length > 0 ? model.D_SHOP_TIME : @"",*/
					  model.D_LEAD_TIME.length > 0 ? model.D_LEAD_TIME : @"",
					  model.X_REMARK.length > 0 ? model.X_REMARK : @"", nil];
	return array;
}
@end
