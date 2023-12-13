//
//  OnlineExhibtionSettingViewController.h
//  mcr_s
//
//  Created by bipyun on 16/11/4.
//  Copyright © 2016年 match. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlineExhibtionSettingViewController : DBBaseViewController
@property (strong, nonatomic) IBOutlet UITableView *mainTab;
- (IBAction)addNutton:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIView *samllView;
@property (strong, nonatomic) IBOutlet UILabel *line1;
@property (strong, nonatomic) IBOutlet UILabel *line2;
- (IBAction)cancelBtn:(id)sender;
- (IBAction)sureBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *addressText;
@property (strong, nonatomic) IBOutlet UITextField *IPaddress;
@property (strong, nonatomic) IBOutlet UILabel *titleType;

@end
