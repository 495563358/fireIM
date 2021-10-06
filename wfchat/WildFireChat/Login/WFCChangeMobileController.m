//
//  WFCChangeMobileController.m
//  WildFireChat
//
//  Created by oopshome on 2021/10/6.
//  Copyright © 2021 WildFireChat. All rights reserved.
//

#import "WFCChangeMobileController.h"
#import <WFChatUIKit/WFChatUIKit.h>
#import "UIColor+YH.h"
#import "UIFont+YH.h"
#import "MBProgressHUD.h"
#import "AppService.h"

@interface WFCChangeMobileController ()

@property (copy, nonatomic) NSString *mobile;
@property (strong, nonatomic) UITextField *userNameField;
@property (strong, nonatomic) UIButton *loginBtn;
@end

@implementation WFCChangeMobileController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
    self.title = self.mobile ? @"修改手机号" : @"绑定手机号";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //view1
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kzSCREEN_WIDTH, 53)];
    view1.backgroundColor = [UIColor whiteColor];
    
    if (self.mobile && self.mobile.length) {
        UILabel *labdesc = [[UILabel alloc] initWithFrame:CGRectMake(19, 0, 150, 53)];
        labdesc.font = [UIFont systemFontOfSize:15];
        labdesc.textColor = [UIColor blackColor];
        labdesc.text = @"已绑定手机号";
        
        UILabel *mobileL = [[UILabel alloc] initWithFrame:CGRectMake(kzSCREEN_WIDTH - 200, 0, 181, 53)];
        mobileL.font = [UIFont systemFontOfSize:12];
        mobileL.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
        mobileL.text = self.mobile;
        mobileL.textAlignment = NSTextAlignmentRight;
        [view1 addSubview:labdesc];
        [view1 addSubview:mobileL];
    } else {
        UILabel *labdesc = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kzSCREEN_WIDTH, 53)];
        labdesc.font = [UIFont systemFontOfSize:15];
        labdesc.textColor = [UIColor colorWithRed:139/255.0 green:139/255.0 blue:139/255.0 alpha:1];
        labdesc.textAlignment = NSTextAlignmentCenter;
        labdesc.text = @"尚未绑定手机号码";
        [view1 addSubview:labdesc];
    }
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight + 63, kzSCREEN_WIDTH, 53)];
    view2.backgroundColor = [UIColor whiteColor];
    self.userNameField = [[UITextField alloc] initWithFrame:CGRectMake(18, 0, kzSCREEN_WIDTH - 36, 53)];
    self.userNameField.font = [UIFont systemFontOfSize:16];
    self.userNameField.placeholder = self.mobile ? @"请输入需要更换绑定的手机号" : @"请输入需要绑定的手机号";
    self.userNameField.returnKeyType = UIReturnKeyDone;
    self.userNameField.keyboardType = UIKeyboardTypeNumberPad;
    self.userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [view2 addSubview:self.userNameField];
    
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    
    
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake((kzSCREEN_WIDTH - 166)/2, 200 + kStatusBarAndNavigationBarHeight, 166, 44)];
    [self.loginBtn addTarget:self action:@selector(onLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 4.f;
    [self.loginBtn setTitle:@"确认绑定" forState:UIControlStateNormal];
    self.loginBtn.backgroundColor = [UIColor colorWithHexString:@"#3B62E1"];
    [self.loginBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16];
    self.loginBtn.enabled = YES;
    [self.view addSubview:self.loginBtn];
}

- (void)onLoginButton:(id)sender {
    NSString *localMobile = self.userNameField.text;
  
    if (!localMobile.length) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"处理中...";
    [hud showAnimated:YES];
    [[AppService sharedAppService] changeMobile:localMobile success:^(NSString * _Nonnull userId, NSString * _Nonnull token, NSString * _Nonnull mobile, BOOL newUser) {
        if (localMobile && localMobile.length && ![localMobile isKindOfClass:NSNull.class]){
            [[NSUserDefaults standardUserDefaults] setObject:localMobile forKey:@"mobile"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        });
    } error:^(int errCode, NSString * _Nonnull message) {
            NSLog(@"login error with code %d, message %@", errCode, message);
          dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"修改失败";
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:1.f];
          });
    }];
    
}

@end
