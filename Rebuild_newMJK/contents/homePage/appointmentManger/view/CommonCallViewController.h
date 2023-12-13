//
//  CommonCallViewController.h
//  mcr_s
//
//  Created by bipyun on 16/9/5.
//  Copyright © 2016年 match. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonCallViewController : DBBaseViewController
@property(nonatomic,strong)NSString *UrlStr;

@property(nonatomic,strong)NSString *Str;
@property(nonatomic,strong)NSString *nameStr;
@property(nonatomic,strong)NSString *callStr;
@property(nonatomic,strong)NSString *typeStr;
@property(nonatomic,strong)NSString *C_OWNER_ROLEID;
@property (strong, nonatomic) IBOutlet UIImageView *imgview;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *callLabel;
@property (strong, nonatomic) IBOutlet UILabel *type;
- (IBAction)callButton:(id)sender;
- (IBAction)cancelButton:(id)sender;

@end
