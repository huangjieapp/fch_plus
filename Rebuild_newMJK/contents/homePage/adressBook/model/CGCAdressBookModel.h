//
//  CGCAdressBookModel.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CGCAdressBookDetailModel;
@interface CGCAdressBookModel : MJKBaseModel

@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, copy) NSString *total;

@property (nonatomic, strong) CGCAdressBookDetailModel *model;
@end
