//
//  MJKBusinessConfigView.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/7/3.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKBusinessConfigView.h"

@implementation MJKBusinessConfigView



- (void)setFrame:(CGRect)frame {
    frame.origin.y = SafeAreaTopHeight;
    frame.size.height = KScreenHeight - SafeAreaTopHeight;
    frame.size.width = KScreenWidth;
    [super setFrame:frame];
}

@end
