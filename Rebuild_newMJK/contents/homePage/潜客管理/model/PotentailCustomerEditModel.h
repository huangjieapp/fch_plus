//
//  PotentailCustomerEditModel.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/18.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PotentailCustomerEditModel : MJKBaseModel

@property(nonatomic,strong)NSString*locatedTitle;



@property(nonatomic,strong)NSString*nameValue;    //默认都是@“” 是用来显示的
@property(nonatomic,strong)NSString*postValue;  //传值的时候 传的value
@property(nonatomic,strong)NSString*keyValue;    //传入commit的值


@end
