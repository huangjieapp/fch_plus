//
//  ThreeInputView.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/11/1.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^clickCancelBlock)();
typedef void(^clickSureBlock)(NSString*firstText,NSString*secondText,NSString*thirdText);


@interface ThreeInputView : UIView

+(instancetype)showThreeInputViewAndSuccess:(clickSureBlock)sureBlock andCancel:(clickCancelBlock)cancelBlock;
@property(nonatomic,assign)BOOL canCommitNoAll;  //是否三个 都必须填写


@property(nonatomic,copy)clickCancelBlock cancelBlock;
@property(nonatomic,copy)clickSureBlock sureBlock;



@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *topLab;
@property (weak, nonatomic) IBOutlet UILabel *subLab;
@property (weak, nonatomic) IBOutlet UITextField *firstTextF;
@property (weak, nonatomic) IBOutlet UITextField *secondTextF;
@property (weak, nonatomic) IBOutlet UITextField *thirdTextF;


@end
