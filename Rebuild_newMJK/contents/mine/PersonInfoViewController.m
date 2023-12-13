//
//  PersonInfoViewController.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/10.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "PersonInfoTableViewCell.h"

#import "PersonInfoDatasModel.h"



#define CELL0    @"PersonInfoTableViewCell"

@interface PersonInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UIButton*imageButton;
@property(nonatomic,strong)NSMutableArray*localDatas;

@end

@implementation PersonInfoViewController

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
	self.title = @"个人信息";
    [self getlocalDatas];
    
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self addBottomView];
    
    
    

     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    
}

#pragma mark  --UI
-(void)addBottomView{
    UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-80, KScreenWidth, 80)];
    mainView.backgroundColor=self.tableView.backgroundColor;
    [self.view addSubview:mainView];
    
    UIButton*commitButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, KScreenWidth-20, 50)];
    [commitButton setBackgroundColor:KNaviColor];
    [commitButton setTitleColor:[UIColor blackColor]];
    [commitButton setTitleNormal:@"提交"];
    [commitButton addTarget:self action:@selector(clickCommit)];
    [mainView addSubview:commitButton];
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.localDatas.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonInfoTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.indexRow=indexPath.row;
    PersonInfoDatasModel*model=self.localDatas[indexPath.row];
    cell.myTextField.placeholder=model.placeholderStr;
    cell.myTextField.text=model.showStr;
    cell.changeTextFieldBlock = ^(NSString *textStr, NSInteger indexRow) {
        MyLog(@"--%@  ,-%ld    %@",textStr,(long)indexRow,model);
        model.showStr=textStr;
        
    };
    
    
    if (indexPath.row==1) {
        cell.type=textFieldTypePhone;
//    }else if (indexPath.row==2||indexPath.row==3){
//        cell.type=textFieldTypePhone;
    }
    
    else if (indexPath.row==2){
        cell.type=textFieldTypeEmail;
    }
    
    
    
    cell.myTextField.delegate=self;
    
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 140)];
    mainView.backgroundColor=[UIColor clearColor];
    
    UIButton*imageButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 15, 95, 95)];
    self.imageButton=imageButton;
    imageButton.imageView.contentMode=UIViewContentModeScaleAspectFill;
    imageButton.centerX=mainView.centerX;
    [imageButton addTarget:self action:@selector(clickChoosePhoto)];
    imageButton.layer.cornerRadius=95/2;
    imageButton.layer.masksToBounds=YES;
    if ([NewUserSession instance].user.avatar&&![[NewUserSession instance].user.avatar isEqualToString:@""]) {
        [imageButton sd_setImageWithURL:[NSURL URLWithString:[NewUserSession instance].user.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"设置头像"]];
    }else{
        [imageButton setImage:[UIImage imageNamed:@"placeholder"] forState:UIControlStateNormal];
    }
    [mainView addSubview:imageButton];
    
    
    return mainView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 140;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}


#pragma mark  --delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //    定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (!newPhoto) {
        newPhoto=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
//    NSData*data=UIImagePNGRepresentation(newPhoto);
    NSData *data = UIImageJPEGRepresentation(newPhoto, 0.5);

    
    [self.imageButton setImage:newPhoto forState:UIControlStateNormal];
    [self HttpPostOneImageToJiekouWith:data];
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark  --click
-(void)clickCommit{
    //名字和 电话不能为空
    PersonInfoDatasModel*model0=self.localDatas[0];
    if (!model0.showStr||[model0.showStr isEqualToString:@""]) {
        [JRToast showWithText:@"名字不能为空"];
        return;
    }
    
    
    PersonInfoDatasModel*model1=self.localDatas[1];
    if (!model1.showStr||[model1.showStr isEqualToString:@""]) {
        [JRToast showWithText:@"电话不能为空"];
        return;
	} else {
		if (model1.showStr.length < 11) {
			[JRToast showWithText:@"手机号码格式不对"];
			return;
		}
	}
	
    
    //提交
    [self httpPostPersonInfo];
    
    
}

-(void)clickChoosePhoto{
    [self TouchAddImage];
    
}


#pragma mark-- datas
-(void)getlocalDatas{
    self.localDatas=[NSMutableArray array];
    
    NSArray*placeholderArray=@[@"姓名",@"手机号码"/*,@"内线号码",@"外线号码"*/,@"邮箱",@"微信号",@"身份证"];
    NSArray*valueArray=@[[NewUserSession instance].user.nickName?[NewUserSession instance].user.nickName:@"",
                         [NewUserSession instance].user.phonenumber?[NewUserSession instance].user.phonenumber:@"",
                         /*[NewUserSession instance].user.C_INTERNAL?[NewUserSession instance].user.C_INTERNAL:@"",
                         [NewUserSession instance].user.C_EXTERNAL?[NewUserSession instance].user.C_EXTERNAL:@"",*/
                          [NewUserSession instance].user.email?[NewUserSession instance].user.email:@"",
                          [NewUserSession instance].user.C_WECHAT?[NewUserSession instance].user.C_WECHAT:@"",
                          [NewUserSession instance].user.C_IDENTITYCODE?[NewUserSession instance].user.C_IDENTITYCODE:@""];
    NSArray*keyArray=@[@"C_NAME",@"C_MOBILENUMBER"/*,@"C_INTERNAL",@"C_EXTERNAL"*/,@"C_EMAILADDRESS",@"C_WECHAT",@"C_IDENTITYCODE"];
    
    for (int i=0; i<placeholderArray.count; i++) {
        PersonInfoDatasModel*model=[[PersonInfoDatasModel alloc]init];
        model.placeholderStr=placeholderArray[i];
        model.showStr=valueArray[i];
        model.keyStr=keyArray[i];
        [self.localDatas addObject:model];
    }
    
    
    
}



//上传一张照片
-(void)HttpPostOneImageToJiekouWith:(NSData*)data{
    NSString*urlStr=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ipImage"]];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataUpDataHeadPhotoWithUrl:[NSString stringWithFormat:@"%@/api/system/avatar", HTTP_IP] parameters:nil photo:data compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
			[NewUserSession instance].user.avatar=data[@"imgUrl"];
            //show_url  是潜客那块
            NSString*imageStr=data[@"url"];
            
#pragma TODO
            
            
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
        
        
        
    }];
    
    
    
    
}




//提交所有信息
-(void)httpPostPersonInfo{
      NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:HTTP_updatePersonInfo];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    [contentDict setObject:[NewUserSession instance].user.u051Id forKey:@"C_ID"];
    for (PersonInfoDatasModel*model in self.localDatas) {
        if (model.showStr&&![model.showStr isEqualToString:@""]) {
            [contentDict setObject:model.showStr forKey:model.keyStr];
        }
        
    }
    [mtDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
           //成功了   就赋值  然后刷新
            [NewUserSession instance].user.nickName=contentDict[@"C_NAME"];
            [NewUserSession instance].user.phonenumber=contentDict[@"C_MOBILENUMBER"];
            [NewUserSession instance].user.C_INTERNAL=contentDict[@"C_INTERNAL"];
            [NewUserSession instance].user.C_EXTERNAL=contentDict[@"C_EXTERNAL"];
            [NewUserSession instance].user.email=contentDict[@"C_EMAILADDRESS"];
            [NewUserSession instance].user.C_WECHAT=contentDict[@"C_WECHAT"];
            [NewUserSession instance].user.C_IDENTITYCODE=contentDict[@"C_IDENTITYCODE"];
            
            [self.navigationController popViewControllerAnimated:YES];
//            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"message"]];
            [self.tableView reloadData];
        }
        
        
    }];

    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark  --set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight-NavStatusHeight-80) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
    }
    return _tableView;
    
}


#pragma mark  --funcation
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}


- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}



-(void)keyBoardWillHidden:(NSNotification*)notif{
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame = self.view.frame;
        
        frame.origin.y = 0.0;
        
        self.view.frame = frame;
        
    }];
  
}
//开始编辑时 视图上移 如果输入框不被键盘遮挡则不上移。

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[textField convertRect:textField.bounds toView:self.view];

    CGFloat aa = KScreenHeight - (rect.origin.y + rect.size.height + 216 +50+30+50);
//    +self.view.frame.origin.y
    CGFloat rects=aa;
    
    NSLog(@"aa%f",rects);
    
    if (rects <= 0) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            CGRect frame = self.view.frame;
            //frame.origin.y+
            frame.origin.y = rects;
            
            self.view.frame = frame;
            
        }];
        
    }
    
    return YES;
    
}



@end
