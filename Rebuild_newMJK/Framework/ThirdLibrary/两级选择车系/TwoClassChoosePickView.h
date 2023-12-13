//
//  TwoClassChoosePickView.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/11.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^chooseResultBlock)(NSString*firstStr,NSString*secondStr);


@interface TwoClassChoosePickView : UIView

@property(nonatomic,copy)chooseResultBlock completeBlock;
@property(nonatomic,strong)UIPickerView*pickerView;

@property(nonatomic,strong)NSMutableArray*mainDatas;


+(TwoClassChoosePickView*)showTwoClassChoosePickViewWithComplete:(chooseResultBlock)block;

@end
