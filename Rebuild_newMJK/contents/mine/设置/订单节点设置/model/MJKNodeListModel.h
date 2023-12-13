//
//  MJKNodeListModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/13.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKNodeListModel : MJKBaseModel
/** pxList中的key，轨迹id*/
@property (nonatomic, strong) NSString *C_ID;
/** pxList中的key，轨迹排序值*/
@property (nonatomic, assign) NSInteger I_SORTIDX;
@end

NS_ASSUME_NONNULL_END
