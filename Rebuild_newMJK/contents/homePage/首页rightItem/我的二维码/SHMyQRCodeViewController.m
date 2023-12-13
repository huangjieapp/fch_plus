//
//  SHMyQRCodeViewController.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/10.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHMyQRCodeViewController.h"
#import "SHVisitingCardView.h"


@interface SHMyQRCodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImageView;

@property(nonatomic,strong)SHVisitingCardView*VisitView;

@end

@implementation SHMyQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的二维码";
    UIButton*viewerButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    [viewerButton setTitle:@"预览" forState:UIControlStateNormal];
    [viewerButton addTarget:self action:@selector(clickView)];
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithCustomView:viewerButton];
    self.navigationItem.rightBarButtonItem=item;
    
    
}




#pragma mark  --delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
//        UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//    [self.VisitView.imageButton setBackgroundImage:newPhoto forState:UIControlStateNormal];
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
[self.VisitView.imageButton setBackgroundImage:chosenImage forState:UIControlStateNormal];
    
    
}

#pragma mark  -- touch
-(void)clickView{
    [self.VisitView show];
    
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
-(SHVisitingCardView *)VisitView{
    if (!_VisitView) {
        _VisitView=[SHVisitingCardView visitingCardView];
        DBSelf(weakSelf);
        _VisitView.ClickImageButtonBlock=^(){
            [weakSelf TouchAddImage];
            
        };
        [self.view addSubview:_VisitView];
    }
    return _VisitView;
}


#pragma mark  --功能


@end
