//
//  MJKCustomerAddressTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/6.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKCustomerAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfRightLayout;
@property (weak, nonatomic) IBOutlet UIButton *navImage;
@property (weak, nonatomic) IBOutlet UILabel *mustLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomSepLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerSepLayout;
@property (weak, nonatomic) IBOutlet UILabel *chooseAddressLabel;
@property (weak, nonatomic) IBOutlet UITextView *inputAddressTextView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIButton *chooseAreaButton;
@property (nonatomic, copy) void(^selectAreaBlock)(void);
//changeTextBlock

@property (nonatomic, copy) void(^changeTextBlock)(NSString *textStr);
@end

NS_ASSUME_NONNULL_END
