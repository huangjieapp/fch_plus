//
//  MJKClueListSubModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/8/30.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKClueListSubModel : MJKBaseModel

@property (nonatomic, strong) NSString *C_HEADPIC;

@property (nonatomic, strong) NSString *flow_count;

@property (nonatomic, strong) NSString *user_id;

@property (nonatomic, strong) NSString *user_name;


@property (nonatomic, strong) NSString *nickName;

@property (nonatomic, strong) NSString *u031Id;

@property (nonatomic, strong) NSString *u051Id;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *phonenumber;

@property (nonatomic, getter=isSelected) BOOL selected;

/** schedulingCheckFlag 排班是否选中*/
@property (nonatomic, strong) NSString *schedulingCheckFlag;





//只有全部销售才有
@property (nonatomic, strong) NSString *C_NAME;
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_OWNER_ROLEID;
@property (nonatomic, strong) NSString *COUNT;
@property (nonatomic, strong) NSString *isDesign;
@end


//只有全部销售才有
//COUNT = 385;
//"C_HEADPIC" = "http://7xt9pc.com1.z0.glb.clouddn.com/jpeg/2017-10-10/f28d2aa4-e58c-4340-a660-f74c621c34de.jpeg";
//"C_ID" = 00000092;
//"C_NAME" = "\U5218\U6881\U6881";
//"C_OWNER_ROLEID" = 00000094;
