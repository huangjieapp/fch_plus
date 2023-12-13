//
//  DBAssignBottomChooseView.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cancelBlock)();
typedef void(^allChooseBlock)();
typedef void(^sureBlock)();


@interface DBAssignBottomChooseView : UIView
@property(nonatomic,copy)cancelBlock cancelB;
@property(nonatomic,copy)allChooseBlock allChooseB;
@property(nonatomic,copy)sureBlock sureB;



+(instancetype)AssignBottomChooseViewAndcancel:(cancelBlock)cancelB allChoose:(allChooseBlock)allChooseB sure:(sureBlock)sureB;

@end
