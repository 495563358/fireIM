//
//  WFCRegistController.m
//  Wildfire Chat
//
//  Created by WF Chat on 2017/7/9.
//  Copyright © 2017年 WildFireChat. All rights reserved.
//

#import "WFCRegistController.h"
#import <WFChatClient/WFCChatClient.h>
#import <WFChatUIKit/WFChatUIKit.h>
#import "AppDelegate.h"
#import "WFCBaseTabBarController.h"
#import "MBProgressHUD.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "WFCPrivacyViewController.h"
#import "AppService.h"
#import "UIColor+YH.h"
#import "UIFont+YH.h"

//是否iPhoneX YES:iPhoneX屏幕 NO:传统屏幕
#define kIs_iPhoneX ([UIScreen mainScreen].bounds.size.height == 812.0f ||[UIScreen mainScreen].bounds.size.height == 896.0f ||[UIScreen mainScreen].bounds.size.height == 844.0f ||[UIScreen mainScreen].bounds.size.height == 926.0f)

#define kStatusBarAndNavigationBarHeight (kIs_iPhoneX ? 88.f : 64.f)

#define  kTabbarSafeBottomMargin        (kIs_iPhoneX ? 34.f : 0.f)

#define kMainColor          [UIColor colorWithHexString:@"#3B62E1"]

#define HEXCOLOR(rgbValue)                                                                                             \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0                                               \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0                                                  \
blue:((float)(rgbValue & 0xFF)) / 255.0                                                           \
alpha:1.0]

@interface WFCRegistController () <UITextFieldDelegate>
@property (strong, nonatomic) UILabel *hintLabel;
@property (strong, nonatomic) UITextField *userNameField;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) UITextField *rePasswordField;
@property (strong, nonatomic) UIButton *loginBtn;

@property (strong, nonatomic) UIView *userNameLine;
@property (strong, nonatomic) UIView *passwordLine;

@property (strong, nonatomic) UIButton *sendCodeBtn;
@property (nonatomic, strong) NSTimer *countdownTimer;
@property (nonatomic, assign) NSTimeInterval sendCodeTime;
@property (nonatomic, strong) UILabel *privacyLabel;
@end

@implementation WFCRegistController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [WFCUConfigManager globalManager].backgroudColor;
    NSString *savedName = [[NSUserDefaults standardUserDefaults] stringForKey:@"savedName"];
   
    CGRect bgRect = self.view.bounds;
    CGFloat paddingEdge = 38;
    CGFloat hintHeight = 20;
    CGFloat topPos = kStatusBarAndNavigationBarHeight;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kzSCREEN_WIDTH, kStatusBarAndNavigationBarHeight)];
    headerView.backgroundColor = kMainColor;
    [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction)]];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(20,kStatusBarAndNavigationBarHeight - 50 + 16,18,18);
    imageView.image = [UIImage imageNamed:@"jiantou_copy"];
    
    self.hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(53 , kStatusBarAndNavigationBarHeight - 50, 200, 50)];
    self.hintLabel.textColor = [UIColor whiteColor];
    [self.hintLabel setText:@"账号注册"];
    self.hintLabel.textAlignment = NSTextAlignmentLeft;
    self.hintLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:hintHeight];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topPos, kzSCREEN_WIDTH, kzSCREEN_WIDTH*475/375)];
    bgView.image = [UIImage imageNamed:@"login_bg"];
    
    topPos += 75;
    UIImageView *logView = [[UIImageView alloc] initWithFrame:CGRectMake((kzSCREEN_WIDTH - 216)/2, topPos, 216, 74)];
    logView.image = [UIImage imageNamed:@"login_log"];
//    logView.userInteractionEnabled = YES;
//    [logView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSendCode:)]];
    
    topPos += 74 + 45;
    self.userNameField = [[UITextField alloc] initWithFrame:CGRectMake(38, topPos, kzSCREEN_WIDTH - 76, 48)];
    self.userNameField.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
    self.userNameField.placeholder = @"请输入用户名";
    self.userNameField.returnKeyType = UIReturnKeyNext;
    self.userNameField.keyboardType = UIKeyboardTypeASCIICapable;
    self.userNameField.delegate = self;
    self.userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userNameField.borderStyle = UITextBorderStyleRoundedRect;
    self.userNameField.leftView = [self createLeftView:@"login_user"];
    self.userNameField.leftViewMode = UITextFieldViewModeAlways;
    [self.userNameField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    topPos += 48 + 19;
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(38, topPos, kzSCREEN_WIDTH - 76, 48)];
    self.passwordField.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
    self.passwordField.placeholder = @"请输入密码";
    self.passwordField.returnKeyType = UIReturnKeyDone;
    self.passwordField.secureTextEntry = YES;
    self.passwordField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordField.delegate = self;
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.leftView = [self createLeftView:@"login_lock"];
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    [self.passwordField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    topPos += 48 + 19;
    self.rePasswordField = [[UITextField alloc] initWithFrame:CGRectMake(38, topPos, kzSCREEN_WIDTH - 76, 48)];
    self.rePasswordField.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
    self.rePasswordField.placeholder = @"请重复输入密码";
    self.rePasswordField.returnKeyType = UIReturnKeyDone;
    self.rePasswordField.secureTextEntry = YES;
    self.rePasswordField.keyboardType = UIKeyboardTypeASCIICapable;
    self.rePasswordField.delegate = self;
    self.rePasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.rePasswordField.borderStyle = UITextBorderStyleRoundedRect;
    self.rePasswordField.leftView = [self createLeftView:@"login_lock"];
    self.rePasswordField.leftViewMode = UITextFieldViewModeAlways;
    [self.rePasswordField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    topPos += 71;
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(paddingEdge, topPos, bgRect.size.width - paddingEdge * 2, 43)];
    [self.loginBtn addTarget:self action:@selector(onLoginButton:) forControlEvents:UIControlEventTouchDown];
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 4.f;
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    self.loginBtn.backgroundColor = [UIColor colorWithHexString:@"0xe1e1e1"];
    [self.loginBtn setTitleColor:[UIColor colorWithHexString:@"0xb1b1b1"] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16];
    self.loginBtn.enabled = NO;
    
    
    
    [self.view addSubview:headerView];
    [headerView addSubview:imageView];
    [headerView addSubview:self.hintLabel];
    
    [self.view addSubview:bgView];
    [self.view addSubview:logView];
    
    [self.view addSubview:self.userNameField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.rePasswordField];
    
    [self.view addSubview:self.loginBtn];
    
    self.userNameField.text = savedName;
    
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetKeyboard:)]];
    
}

- (UIView *)createLeftView:(NSString *)imageName{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    icon.image = [UIImage imageNamed:imageName];
    [view addSubview:icon];
    return view;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)resetKeyboard:(id)sender {
    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (void)onLoginButton:(id)sender {
    NSString *user = self.userNameField.text;
    NSString *password = self.passwordField.text;
    NSString *repassword = self.rePasswordField.text;
  
    if (!user.length || !password.length) {
        return;
    }
    
    if (![password isEqualToString:repassword]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"两次密码输入不一致";
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:2.f];
        return;
    }
    
    [self resetKeyboard:nil];
    
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud.label.text = @"注册中...";
  [hud showAnimated:YES];
  
    [[AppService sharedAppService] regist:user password:password success:^(NSString * _Nonnull userId, NSString * _Nonnull token, NSString * _Nonnull mobile, BOOL newUser) {
        [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"savedName"];
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"savedToken"];
        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"savedUserId"];
        if (mobile && ![mobile isKindOfClass:NSNull.class] && mobile.length){
            [[NSUserDefaults standardUserDefaults] setObject:mobile forKey:@"mobile"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    //需要注意token跟clientId是强依赖的，一定要调用getClientId获取到clientId，然后用这个clientId获取token，这样connect才能成功，如果随便使用一个clientId获取到的token将无法链接成功。
        [[WFCCNetworkService sharedInstance] connect:userId token:token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
          [hud hideAnimated:YES];
            WFCBaseTabBarController *tabBarVC = [WFCBaseTabBarController new];
            tabBarVC.newUser = newUser;
            [UIApplication sharedApplication].delegate.window.rootViewController =  tabBarVC;
        });
    } error:^(int errCode, NSString * _Nonnull message) {
        NSLog(@"login error with code %d, message %@", errCode, message);
      dispatch_async(dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"注册失败";
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:1.f];
      });
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userNameField) {
        [self.passwordField becomeFirstResponder];
    } else if(textField == self.passwordField) {
        [self onLoginButton:nil];
    }
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.userNameField) {
        self.userNameLine.backgroundColor = [UIColor colorWithRed:0.1 green:0.27 blue:0.9 alpha:0.9];
        self.passwordLine.backgroundColor = [UIColor grayColor];
    } else if (textField == self.passwordField) {
        self.userNameLine.backgroundColor = [UIColor grayColor];
        self.passwordLine.backgroundColor = [UIColor colorWithRed:0.1 green:0.27 blue:0.9 alpha:0.9];
    }
    return YES;
}
#pragma mark - UITextInputDelegate
- (void)textDidChange:(id<UITextInput>)textInput {
    if (textInput == self.userNameField) {
        [self updateBtn];
    } else if (textInput == self.passwordField) {
        [self updateBtn];
    } else if (textInput == self.rePasswordField) {
        [self updateBtn];
    }
}

- (void)updateBtn {
    if ([self isValidNumber]) {
        [self.loginBtn setBackgroundColor:[UIColor colorWithRed:0.1 green:0.27 blue:0.9 alpha:0.9]];
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.loginBtn.enabled = YES;
    } else {
        [self.loginBtn setBackgroundColor:[UIColor grayColor]];
        [self.loginBtn setTitleColor:[UIColor colorWithHexString:@"0xb1b1b1"] forState:UIControlStateNormal];
        self.loginBtn.enabled = NO;
    }
}

- (BOOL)isValidNumber {
    if (self.userNameField.text.length && self.passwordField.text.length && self.rePasswordField.text.length) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isValidCode {
    if (self.passwordField.text.length >= 4) {
        return YES;
    } else {
        return NO;
    }
}
@end
