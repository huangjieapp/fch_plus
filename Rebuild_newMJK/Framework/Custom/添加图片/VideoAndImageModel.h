//
//  VideoAndImageModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2022/2/26.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoAndImageModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *saveUrl;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *imgUrl;
@end

NS_ASSUME_NONNULL_END
