//
//  CGCIntegrateHView.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/6/1.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGCIntegrateHView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *des1;

@property (weak, nonatomic) IBOutlet UILabel *des2;

@property (weak, nonatomic) IBOutlet UILabel *des3;


+(instancetype)getView;

@end
