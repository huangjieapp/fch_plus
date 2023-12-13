//
//  CGCOrderDetialFooter.h
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGCOrderDetialFooter : UIView
@property (nonatomic, assign) BOOL isWork;//汇报列表
@property (nonatomic, assign) BOOL isDetail;
@property (nonatomic, assign) BOOL canEdit;
@property (weak, nonatomic) IBOutlet UIButton *firstPicBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondPicBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdPicBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteOneButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteSecondButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteThirdButton;

//上传图片
@property (weak, nonatomic) IBOutlet UILabel *titleNameLab;

//修改图片之后的值
@property(nonatomic,strong)UIImage*firstImg;
@property(nonatomic,strong)UIImage*secondImg;
@property(nonatomic,strong)UIImage*thirdImg;

//原来的值
@property(nonatomic,strong)NSArray*beforeImageArray;

//如果有image  那就是放大image   没有image 那就去选择image 完成之后  要显示删除按钮
@property(nonatomic,copy)void(^clickFirstBlock)(UIImage*image);
@property(nonatomic,copy)void(^clickSecondBlock)(UIImage*image);
@property(nonatomic,copy)void(^clickThirdBlock)(UIImage*image);

//删除图片
@property(nonatomic,copy)void(^deleteFirstBlock)();
@property(nonatomic,copy)void(^deleteSecondBlock)();
@property(nonatomic,copy)void(^deleteThirdBlock)();

@end
