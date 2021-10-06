//
//  WFCChangePWDController.m
//  WildFireChat
//
//  Created by oopshome on 2021/10/6.
//  Copyright © 2021 WildFireChat. All rights reserved.
//

#import "WFCChangePWDController.h"
#import <WFChatUIKit/WFChatUIKit.h>
#import "UIColor+YH.h"
#import "UIFont+YH.h"
#import "MBProgressHUD.h"
#import "AppService.h"

@interface WFCChangePWDController ()
@property (strong, nonatomic) UITextField *oldPwdTextF;
@property (strong, nonatomic) UITextField *addPwdTextF;
@property (strong, nonatomic) UITextField *addVerifPwdTextF;
@property (strong, nonatomic) UIButton *loginBtn;

@end

@implementation WFCChangePWDController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    CGFloat startY = kStatusBarAndNavigationBarHeight;
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, startY , kzSCREEN_WIDTH, 53)];
    view1.backgroundColor = [UIColor whiteColor];
    self.oldPwdTextF = [[UITextField alloc] initWithFrame:CGRectMake(18, 0, kzSCREEN_WIDTH - 36, 53)];
    self.oldPwdTextF.font = [UIFont systemFontOfSize:16];
    self.oldPwdTextF.placeholder = @"请输入当前密码";
    self.oldPwdTextF.returnKeyType = UIReturnKeyDone;
    self.oldPwdTextF.keyboardType = UIKeyboardTypeASCIICapable;
    self.oldPwdTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [view1 addSubview:self.oldPwdTextF];
    
    [self.view addSubview:view1];
    
    startY += 53;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(18, startY , 200, 46)];
    label1.font = [UIFont boldSystemFontOfSize:14];
    label1.text = @"新密码";
    [self.view addSubview:label1];
    
    startY += 46;
    view1 = [[UIView alloc] initWithFrame:CGRectMake(0, startY , kzSCREEN_WIDTH, 53)];
    view1.backgroundColor = [UIColor whiteColor];
    self.addPwdTextF = [[UITextField alloc] initWithFrame:CGRectMake(18, 0, kzSCREEN_WIDTH - 36, 53)];
    self.addPwdTextF.font = [UIFont systemFontOfSize:16];
    self.addPwdTextF.placeholder = @"请输入新密码";
    self.addPwdTextF.returnKeyType = UIReturnKeyDone;
    self.addPwdTextF.keyboardType = UIKeyboardTypeASCIICapable;
    self.addPwdTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [view1 addSubview:self.addPwdTextF];
    
    [self.view addSubview:view1];
    
    
    startY += 53;
    view1 = [[UIView alloc] initWithFrame:CGRectMake(0, startY , kzSCREEN_WIDTH, 53)];
    view1.backgroundColor = [UIColor whiteColor];
    self.addVerifPwdTextF = [[UITextField alloc] initWithFrame:CGRectMake(18, 0, kzSCREEN_WIDTH - 36, 53)];
    self.addVerifPwdTextF.font = [UIFont systemFontOfSize:16];
    self.addVerifPwdTextF.placeholder = @"请重复输入新密码";
    self.addVerifPwdTextF.returnKeyType = UIReturnKeyDone;
    self.addVerifPwdTextF.keyboardType = UIKeyboardTypeASCIICapable;
    self.addVerifPwdTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [view1 addSubview:self.addVerifPwdTextF];
    
    [self.view addSubview:view1];
    
    startY += 53+57;
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake((kzSCREEN_WIDTH - 166)/2, startY, 166, 44)];
    [self.loginBtn addTarget:self action:@selector(onLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 4.f;
    [self.loginBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    self.loginBtn.backgroundColor = [UIColor colorWithHexString:@"#3B62E1"];
    [self.loginBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16];
    self.loginBtn.enabled = YES;
    [self.view addSubview:self.loginBtn];
}

- (void)onLoginButton:(id)sender {
    NSString *oldPwd = self.oldPwdTextF.text;
    NSString *newPwd = self.addPwdTextF.text;
    NSString *newVerifPwd = self.addVerifPwdTextF.text;
  
    if (!oldPwd.length || !newPwd.length || !newVerifPwd.length) {
        return;
    }
    if (![newPwd isEqualToString:newVerifPwd]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"新密码输入不一致";
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:2.f];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"处理中...";
    [hud showAnimated:YES];
    [[AppService sharedAppService] changePassword:oldPwd newPwd:newPwd success:^(NSString * _Nonnull userId, NSString * _Nonnull token, NSString * _Nonnull mobile, BOOL newUser) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = @"修改密码成功";
            [hud showAnimated:YES];
            [hud hideAnimated:YES afterDelay:2.f];
        });
    } error:^(int errCode, NSString * _Nonnull message) {
        NSLog(@"login error with code %d, message %@", errCode, message);
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = message;
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:2.f];
        });
    }];
    
}

@end
