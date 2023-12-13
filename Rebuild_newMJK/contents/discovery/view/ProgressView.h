//
//  ProgressView.h
//  MZSJ
//
//  Created by 吴伯程 on 16/6/13.
//  Copyright © 2016年 李小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

@property (nonatomic) float progress;
@property (nonatomic, strong) UIColor *drawColor;

/// YES表示隐藏中间的小正方形
@property (nonatomic) BOOL hiddenCenter;

@end
