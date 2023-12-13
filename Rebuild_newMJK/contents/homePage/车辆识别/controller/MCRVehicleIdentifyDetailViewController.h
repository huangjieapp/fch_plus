//
//  MCRVehicleIdentifyDetailViewController.h
//  Mcr_2
//
//  Created by Mcr on 2018/12/7.
//  Copyright © 2018 bipi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MCRVehicleIdentifyDetailViewController : DBBaseViewController

@property(nonatomic,copy)NSString *type;
@property (weak, nonatomic) IBOutlet UIImageView *HeadImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (strong, nonatomic) IBOutlet UILabel *labTime;//到店时间
@property (strong, nonatomic) IBOutlet UILabel *labCarNumber;//车牌号
@property (strong, nonatomic) IBOutlet UILabel *labCarColor;//车牌颜色
@property (weak, nonatomic) IBOutlet UILabel *labCustomer;
@property (weak, nonatomic) IBOutlet UILabel *labYuyue;

@property(strong,nonatomic)NSDictionary* dic;

@end


