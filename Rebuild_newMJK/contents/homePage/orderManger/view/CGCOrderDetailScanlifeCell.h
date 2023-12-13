//
//  CGCOrderDetailScanlifeCell.h
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    CGCOrderDetailScanlifeCellDisplay,//正常展示
   CGCOrderDetailScanlifeCellEidt//编辑和新增
    
}CGCOrderDetailScanlifeCellStyle;

@interface CGCOrderDetailScanlifeCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView withType:(CGCOrderDetailScanlifeCellStyle)type;

@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet UITextView *textView;


@property (weak, nonatomic) IBOutlet UIButton *scanlifeBtn;

@end
