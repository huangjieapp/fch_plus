//
//  AddCustomerProductTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCustomerProductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mustLabel;
@property (weak, nonatomic) IBOutlet UIButton *scanfButton;
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTitltLabelLeftLayout;
@property (weak, nonatomic) IBOutlet UITextView *textView;
/** root vc*/
@property (nonatomic, weak) UIViewController *rootVC;
@property (nonatomic, assign) BOOL isNoPrice;
/** 产品*/
@property (nonatomic, strong) NSArray *productArray;
@property(nonatomic,strong)NSString*textViewStr;
@property(nonatomic,copy)void(^clickSanfBlock)();
@property(nonatomic,copy)void(^textViewChangeBlock)(NSString*currentStr);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
