//
//  MCRVehicleIdentifyDetailViewController.m
//  Mcr_2
//
//  Created by bipi on 2017/4/19.
//  Copyright © 2017年 bipi. All rights reserved.
//

#import "MCRVehicleIdentifyDetailViewController.h"


#import "KSPhotoItem.h"
#import "KSPhotoBrowser.h"
@interface MCRVehicleIdentifyDetailViewController ()

@end

@implementation MCRVehicleIdentifyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"车牌识别";
    
    [self CreateUI];
   
}

-(void)CreateUI{
    [_HeadImageView  sd_setImageWithURL:[NSURL URLWithString:[self.dic objectForKey:@"C_PICURL"]]];
    _HeadImageView.layer.cornerRadius = 5;
    [_HeadImageView.layer setMasksToBounds:YES];
    _labTime.text = [self.dic objectForKey:@"D_ARRIVAL_TIME"];
    _labCarNumber.text = [self.dic objectForKey:@"C_LICENSENUMBER"];
    _labCustomer.text = [self.dic objectForKey:@"C_NAME"];
    _labYuyue.text = [[self.dic objectForKey:@"I_TYPE"] isEqualToString:@"0"] ? @"未预约" : @"已预约";
}
- (IBAction)showBigImage:(UITapGestureRecognizer *)sender {
    KSPhotoItem * item=[KSPhotoItem itemWithSourceView:_HeadImageView image:_HeadImageView.image];
    KSPhotoBrowser * browser=[KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
    [browser showFromViewController:self];
}

@end
