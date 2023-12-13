//
//  MJKImageView.h
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/16.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKImageView : UIImageView
+ (instancetype)loadImageViewWithFrame:(CGRect)frame andcornerRadius:(CGFloat)radius andImage:(NSString *)imageStr;
@end
