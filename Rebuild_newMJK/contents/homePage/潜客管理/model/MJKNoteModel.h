//
//  MJKNoteModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/25.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKNoteModel : MJKBaseModel
/** 标签id*/
@property (nonatomic, strong) NSString *C_ID;
/** 标签*/
@property (nonatomic, strong) NSString *C_NAME;
@property (nonatomic, strong) NSString *C_COLOR_DD_ID;
@end
