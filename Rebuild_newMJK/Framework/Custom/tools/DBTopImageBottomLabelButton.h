//
//  TopImageButton.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/1.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

//很好的一个概念  创建的时候 选择 图片和文字的位置设置   没有做需要跟进
typedef NS_ENUM(NSUInteger, MKButtonEdgeInsetsStyle) {
    MKButtonEdgeInsetsStyleTop, // image在上，label在下
    MKButtonEdgeInsetsStyleLeft, // image在左，label在右
    MKButtonEdgeInsetsStyleBottom, // image在下，label在上
    MKButtonEdgeInsetsStyleRight // image在右，label在左
};



@interface DBTopImageBottomLabelButton : UIButton
@property(nonatomic,strong)UIImageView*TopImageView;
@property(nonatomic,strong)UILabel*BottomLabel;
@end
