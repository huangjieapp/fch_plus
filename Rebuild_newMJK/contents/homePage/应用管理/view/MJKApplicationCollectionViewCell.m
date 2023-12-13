//
//  MJKApplicationCollectionViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/5.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKApplicationCollectionViewCell.h"

@interface MJKApplicationCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *indicateImageV;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;

@end

@implementation MJKApplicationCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setModel:(MJKManagerModuleModel *)model{
    _model=model;
    self.titleLab.text=model.name;
    self.iconImageV.image=[UIImage imageNamed:model.imageName];
//    if ([[NewUserSession instance].hotappList containsObject:model.code]) {
//        self.hotImageView.hidden = NO;
//    } else {
        self.hotImageView.hidden = YES;
//    }
	//icon_more_module_unselected
	
}



-(void)setIsSelected:(BOOL)isSelected{
    _isSelected=isSelected;
    if (self.appType==ApplicationTypeMyApp) {
        if (self.isSelected==YES) {
            //删除应用
            self.mainView.layer.borderWidth=1;
            self.mainView.layer.borderColor=DBColor(246, 246, 246).CGColor;
            
            self.indicateImageV.hidden=NO;
            self.indicateImageV.image=[UIImage imageNamed:@"deleteApplication"];
            
            
        }else{
            //普通模式
            self.mainView.layer.borderWidth=0;
            self.mainView.layer.borderColor=nil;
            
            self.indicateImageV.hidden=YES;
            self.indicateImageV.image=nil;

            
        }
        
        
    }else if (self.appType==ApplicationTypeModule){
		
        if (self.isSelected==YES) {
            self.mainView.layer.borderWidth=1;
            self.mainView.layer.borderColor=DBColor(246, 246, 246).CGColor;

            
            //判断是否能添加  能添加 就添加
            if (self.model.isSelected) {
                self.indicateImageV.hidden=NO;
                self.indicateImageV.image=[UIImage imageNamed:@"selectedApplication"];

            }else{
                self.indicateImageV.hidden=NO;
                self.indicateImageV.image=[UIImage imageNamed:@"addApplication"];
				if (![[NewUserSession instance].hotappList containsObject:self.model.code] && self.model.isBuy == NO) {
					self.indicateImageV.image = [UIImage imageNamed:@"icon_more_module_unselected"];
				}
				
            }
			
            
        }else{
            //普通模式
            self.mainView.layer.borderWidth=0;
            self.mainView.layer.borderColor=nil;
            
            self.indicateImageV.hidden=YES;
            self.indicateImageV.image=nil;

            
            
        }
        
        
    }

    
    
    
}




@end
