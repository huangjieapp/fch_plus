//
//  CGCOrderDetialFooter.m
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "CGCOrderDetialFooter.h"//订单详情里的底部上传图片

@interface CGCOrderDetialFooter()




//有图片显示  没有图片隐藏


@property(nonatomic,strong)NSMutableArray*saveAllButton;
@property(nonatomic,strong)NSMutableArray*saveDeleteButton;
@end

@implementation CGCOrderDetialFooter


-(void)awakeFromNib{
    [super awakeFromNib];
    [self.firstPicBtn addTarget:self action:@selector(clickFirstPicBtn:)];
    [self.secondPicBtn addTarget:self action:@selector(clickSecondPicBtn:)];
    [self.thirdPicBtn addTarget:self action:@selector(clickThirdPicBtn:)];
    
    self.saveAllButton=[NSMutableArray array];
    [self.saveAllButton addObject:self.firstPicBtn];
    [self.saveAllButton addObject:self.secondPicBtn];
    [self.saveAllButton addObject:self.thirdPicBtn];
    
    
    self.saveDeleteButton=[NSMutableArray array];
    [self.saveDeleteButton addObject:self.deleteOneButton];
    [self.saveDeleteButton addObject:self.deleteSecondButton];
    [self.saveDeleteButton addObject:self.deleteThirdButton];
    
    
    
}


#pragma mark  -- click
-(void)clickFirstPicBtn:(UIButton*)button{
    UIImage*image=button.imageView.image;
//    UIImage*image2=button.currentBackgroundImage;
    
    if (image&&image.size.width==18) {
        //当前是没有图片 要选择图片
		if (self.isDetail == NO) {
			if (self.clickFirstBlock) {
				self.clickFirstBlock(nil);
			}
		}
		

        
        
    }else if (image){
        //放大这个图片
        if (self.clickFirstBlock) {
            self.clickFirstBlock(image);
        }

        
    }
    
    
    
}

-(void)clickSecondPicBtn:(UIButton*)button{
     UIImage*image=button.imageView.image;
    if (image&&image.size.width==18) {
        //当前是没有图片 要选择图片
		if (self.isDetail == NO) {
			if (self.clickSecondBlock) {
				self.clickSecondBlock(nil);
			}
		}
		

        
        
        
    }else if (image){
        //放大这个图片
        if (self.clickSecondBlock) {
            self.clickSecondBlock(image);
        }
        
        
    }

    
    
    
}

-(void)clickThirdPicBtn:(UIButton*)button{
    UIImage*image=button.imageView.image;
    if (image&&image.size.width==18) {
        //当前是没有图片 要选择图片
		if (self.isDetail == NO) {
			if (self.clickThirdBlock) {
				self.clickThirdBlock(nil);
			}
		}
		
        
        
        
        
    }else if (image){
        //放大这个图片
        if (self.clickThirdBlock) {
            self.clickThirdBlock(image);
        }
        
        
    }

    
    
    
    
}




- (IBAction)clickDeleteFirstBtn:(id)sender {
    if (self.deleteFirstBlock) {
        self.deleteFirstBlock();
        self.firstImg=[UIImage imageNamed:@"head+"];
        self.deleteOneButton.hidden=YES;
    }
    
}

- (IBAction)clickDeleteSecondBtn:(id)sender {
    if (self.deleteSecondBlock) {
        self.deleteSecondBlock();
        self.secondImg=[UIImage imageNamed:@"head+"];
        self.deleteSecondButton.hidden=YES;
    }

    
}

- (IBAction)clickDeleteThirdBtn:(id)sender {
    if (self.deleteThirdBlock) {
        self.deleteThirdBlock();
        self.thirdImg=[UIImage imageNamed:@"head+"];
        self.deleteThirdButton.hidden=YES;
    }

    
}


#pragma mark  --set
-(void)setBeforeImageArray:(NSArray *)beforeImageArray{
    _beforeImageArray=beforeImageArray;
	if (self.isWork == YES) {
		UIButton*button0=self.saveAllButton[0];
		UIButton*button1=self.saveAllButton[1];
		UIButton*button2=self.saveAllButton[2];
		if (beforeImageArray.count == 1) {
			button1.hidden = YES;
			button2.hidden = YES;
		} else if (beforeImageArray.count == 2) {
			button2.hidden = YES;
		} else if (beforeImageArray.count == 3) {
			button0.hidden = NO;
			button1.hidden = NO;
			button2.hidden = NO;
		}
	}
    
    if (/*beforeImageArray.count>3||*/beforeImageArray.count<1||[beforeImageArray[0] isEqualToString:@""]) {
		//如果没有照片
//		self.firstImg=[UIImage imageNamed:@"head+"];
//		self.secondImg=[UIImage imageNamed:@"head+"];
//		self.thirdImg=[UIImage imageNamed:@"head+"];
//
//		self.deleteOneButton.hidden=YES;
//		self.deleteSecondButton.hidden=YES;
//		self.deleteThirdButton.hidden=YES;
		
        return;
    }
    
    NSInteger count = beforeImageArray.count > 3 ? 3 : beforeImageArray.count;
    for (int i=0; i<count; i++) {
        if ([beforeImageArray[i] isEqualToString:@"xxx"]) {
            //不知道可行哇
            
        }else{
        
        UIButton*button=self.saveAllButton[i];
        [button sd_setImageWithURL:[NSURL URLWithString:beforeImageArray[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        UIButton*deleteBtn=self.saveDeleteButton[i];
        deleteBtn.hidden=NO;
        }
        
    }
    
}


-(void)setFirstImg:(UIImage *)firstImg{
    _firstImg=firstImg;
     UIButton*button=self.saveAllButton[0];
    if (firstImg&&button) {
        [button setImage:firstImg forState:UIControlStateNormal];
		if (self.isDetail == YES) {
			self.deleteOneButton.hidden=YES;
		} else {
        self.deleteOneButton.hidden=NO;
		}
    }
    
}

-(void)setSecondImg:(UIImage *)secondImg{
    _secondImg=secondImg;
    UIButton*button=self.saveAllButton[1];
    if (secondImg&&button) {
        [button setImage:secondImg forState:UIControlStateNormal];
		if (self.isDetail == YES) {
			self.deleteSecondButton.hidden=YES;
		} else {
        self.deleteSecondButton.hidden=NO;
		}
    }
}

-(void)setThirdImg:(UIImage *)thirdImg{
    _thirdImg=thirdImg;
    UIButton*button=self.saveAllButton[2];
    if (thirdImg&&button) {
        [button setImage:thirdImg forState:UIControlStateNormal];
		if (self.isDetail == YES) {
			self.deleteThirdButton.hidden=YES;
		} else {
        self.deleteThirdButton.hidden=NO;
		}
    }
    
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.firstPicBtn.layer.borderWidth=0.5;
    self.firstPicBtn.layer.borderColor=DBColor(0, 0, 0).CGColor;
    self.firstPicBtn.layer.cornerRadius=4.0;
    self.firstPicBtn.layer.masksToBounds=YES;
    
    self.secondPicBtn.layer.borderWidth=0.5;
    self.secondPicBtn.layer.borderColor=DBColor(0, 0, 0).CGColor;
    self.secondPicBtn.layer.cornerRadius=4.0;
    self.secondPicBtn.layer.masksToBounds=YES;
    
    
    self.thirdPicBtn.layer.borderWidth=0.5;
    self.thirdPicBtn.layer.borderColor=DBColor(0, 0, 0).CGColor;
    self.thirdPicBtn.layer.cornerRadius=4.0;
    self.thirdPicBtn.layer.masksToBounds=YES;
    
}




@end
