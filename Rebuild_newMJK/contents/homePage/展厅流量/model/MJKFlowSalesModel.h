//
//  MJKFlowSalesModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/8.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKFlowSalesModel : MJKBaseModel

@property (nonatomic, strong) NSString *COUNT;
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_NAME;
@property (nonatomic, strong) NSString *C_OWNER_ROLEID;
@property (nonatomic, strong) NSString *C_HEADPIC;
@property (nonatomic, getter=isSelected) BOOL selected;
@end
