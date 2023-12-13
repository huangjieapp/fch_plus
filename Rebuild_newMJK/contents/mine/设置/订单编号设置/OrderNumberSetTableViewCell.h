//
//  OrderNumberSetTableViewCell.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/9/22.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderNumberSetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *TextFie;

@property(nonatomic,copy)void(^changeTextFieBlock)(NSString*textStr);

@end
