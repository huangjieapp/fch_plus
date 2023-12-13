//
//  PickerChoiceView.h
//  TFPickerView
//
//  Created by TF_man on 16/5/11.
//  Copyright © 2016年 tituanwang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PickerChoiceView;
@protocol TFPickerDelegate <NSObject>

@optional;

- (void)PickerSelectorIndixString:(NSString *)str;

- (void)PickerSelectorIndixColour:(UIColor *)color;



//城市 这里 两个都有？
- (void)Picker:(PickerChoiceView *)pick SelectorIndixString:(NSString *)str;
@end


typedef NS_ENUM(NSInteger, ARRAYTYPE) {
    //只用到  arrayChoose  和    deteArray    如果是两维数据 选中cell 失效    省市的换个框架
    ArrayChoose=0,   //传入的数据选择
    DeteArray,        //日期
    
    
    
    
    GenderArray,    //性别
    HeightArray,     //身高
    weightArray,    //体重
    DeteAndTimeArray,   //日期和时间
    ColourArray,
    AppiontmentDateType,//预约时间
    sellType //销售顾问
    
    
    
    
};

@interface PickerChoiceView : UIView
//设置类型
@property (nonatomic, assign) ARRAYTYPE arrayType;

@property (nonatomic,assign)id<TFPickerDelegate>delegate;
//选中
@property (nonatomic,strong)NSString *selectStr;

//自定义类型
@property (nonatomic, strong) NSArray *customArr;
//标题的名字
@property(nonatomic,strong)NSString*titleStr;

@property (nonatomic,strong)UILabel *selectLb;

- (instancetype)initWithFrame:(CGRect)frame withArray:(NSMutableArray * )arr ;





//乱死了
- (instancetype)initWithFrame:(CGRect)frame withArray:(NSMutableArray * )arr withType:(ARRAYTYPE)arrayType andSelectStr:(NSString*)selectedStr  andTitleText:(NSString*)titleStr;

@property(nonatomic,copy)void(^clickCompleteBlock)(NSString*title,NSInteger number);

@end
