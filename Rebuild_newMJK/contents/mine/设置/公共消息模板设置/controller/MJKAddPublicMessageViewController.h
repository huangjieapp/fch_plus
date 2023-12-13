//
//  MJKAddPublicMessageViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/14.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CGCTalkModel;

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
	PublicMessageAdd,
	PublicMessageEdit,
} PublicMessageType;

@interface MJKAddPublicMessageViewController : DBBaseViewController
/** CGCTalkModel*/
@property (nonatomic, strong) CGCTalkModel *model;
/** PublicMessageType*/
@property (nonatomic, assign) PublicMessageType type;
@end

NS_ASSUME_NONNULL_END
