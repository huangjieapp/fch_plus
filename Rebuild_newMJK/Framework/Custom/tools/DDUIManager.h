//
//  DDUIManager.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/27.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DDUIManager : NSObject
@property (nonatomic, assign, readonly) UIEdgeInsets safeAreaInset;
/*
 * 是否是刘海屏
 * */
@property (nonatomic, assign, readonly) BOOL isHairHead;

+ (instancetype)sharedManager;
@end

