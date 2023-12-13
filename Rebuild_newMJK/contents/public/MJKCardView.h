//
//  MJKCardView.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/1/22.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKCardView : UIView
@property (weak, nonatomic) IBOutlet UIView *thisCardView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
/** <#注释#>*/
@property (nonatomic, strong) NSString *vcName;
/** <#注释#>*/
@property (nonatomic, strong) NSString *qrCodeStr;
@property (nonatomic, weak) UIViewController *rootVC;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
/** <#备注#>*/
@property (nonatomic, copy) void(^editButtonActionBlock)(UIImage *image);
@property (nonatomic, copy) void(^showButtonActionBlock)(void);
@property (weak, nonatomic) IBOutlet UIView *editBGView;
@property (weak, nonatomic) IBOutlet UILabel *editLabel;
@end

NS_ASSUME_NONNULL_END
