//
//  HelperModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/4.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelperMainModel : MJKBaseModel
@property (nonatomic, strong) NSArray *content;
@end

@interface HelperModel : MJKBaseModel
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_ASSISTANT;
@property (nonatomic, strong) NSString *C_ASSISTANTNAME;
@property (nonatomic, strong) NSString *D_CREATE_TIME;
@property (nonatomic, strong) NSString *C_HEADIMGURL;
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
@end
