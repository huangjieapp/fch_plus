//
//  AddCustomerPhotoTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCustomerPhotoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mustbeLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;


@property(nonatomic,copy)void(^clickPortraitBlock)();
@property(nonatomic,copy)void(^changeTextFieldBlock)(NSString*currentStr);
@property(nonatomic,strong)NSString*portraitStr;
@property(nonatomic,strong)NSString*nameStr;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
