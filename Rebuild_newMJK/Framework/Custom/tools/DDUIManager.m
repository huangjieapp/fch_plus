//
//  DDUIManager.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/27.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "DDUIManager.h"


static DDUIManager*manager=nil;
@implementation DDUIManager
+ (instancetype)sharedManager {
	if (manager==nil) {
		manager=[[DDUIManager alloc]init];
	}
	return manager;
}

- (UIWindow *)keyWindow {
	return [UIApplication sharedApplication].keyWindow;
}

- (UIEdgeInsets)safeAreaInset {
	if (@available(iOS 11.0, *)) {
		if (self.keyWindow) {
			return self.keyWindow.safeAreaInsets;
		}
	}
	return UIEdgeInsetsZero;
}

- (BOOL)isHairHead {
	if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
		return self.safeAreaInset.left > 0.0f;
	}else {
		// ios12 非刘海屏状态栏 20.0f
		return self.safeAreaInset.top > 20.0f;
	}
}

@end
