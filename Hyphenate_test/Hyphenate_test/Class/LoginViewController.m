/************************************************************
  *  * Hyphenate CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2016 Hyphenate Inc. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of Hyphenate Inc.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from Hyphenate Inc.
  */

#import "LoginViewController.h"
#import "EMError.h"
#import "ChatDemoHelper.h"
#import "MBProgressHUD.h"
//#import "RedPacketUserConfig.h"
//#import "MBProgressHUD+Add.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UISwitch *useIpSwitch;

- (IBAction)doRegister:(id)sender;
- (IBAction)doLogin:(id)sender;
- (IBAction)useIpAction:(id)sender;

@end

@implementation LoginViewController

@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize registerButton = _registerButton;
@synthesize loginButton = _loginButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
   
    [super viewDidLoad];
     self.title = @"登录";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupForDismissKeyboard];
    _usernameTextField.delegate = self;
    _passwordTextField.delegate = self;
    
    NSString *username = [self lastLoginUsername];
    if (username && username.length > 0) {
        _usernameTextField.text = username;
    }
    
//    [_useIpSwitch setOn:[[EMClient sharedClient].options enableDnsConfig] animated:YES];
    
    self.title = NSLocalizedString(@"AppName", @"EaseMobDemo");
    
    [self hyphenateInit];
}


-(void)hyphenateInit{
    
//    EMOptions *options = [EMOptions optionsWithAppkey:EaseMobAppKey];
//    NSString *apnsCertName = nil;
//#if DEBUG
//    apnsCertName = @"chatdemoui_dev";
//#else
//    apnsCertName = @"chatdemoui";
//#endif
//    //        options.apnsCertName = apnsCertName;
//    [[EMClient sharedClient] initializeSDKWithOptions:options];
//    //添加回调监听代理:
////    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//注册账号
//Registered account
- (IBAction)doRegister:(id)sender {
    
    
    
    WeakObj(self);
    [[EMClient sharedClient] registerWithUsername:weakself.usernameTextField.text password:weakself.passwordTextField.text completion:^(NSString *aUsername, EMError *aError) {
        
        if (!aError) {
            NSLog(@"register.success");
        }else{
            switch (aError.code) {
                case EMErrorServerNotReachable:
                    NSLog(@"error.connectServerFail");
                    
                    [MBProgressHUD showSuccess:@"error.connectServerFail" toView:self.view];
                    break;
                case EMErrorUserAlreadyExist:
                    NSLog(@"register.repeat");
                    [MBProgressHUD showSuccess:@"register.repeat" toView:self.view];
                    break;
                case EMErrorNetworkUnavailable:
                    NSLog(@"error.connectNetworkFail");
                    [MBProgressHUD showSuccess:@"error.connectNetworkFail" toView:self.view];
                    break;
                case EMErrorServerTimeout:
                    NSLog(@"error.connectServerTimeout");
                    [MBProgressHUD showSuccess:@"error.connectServerTimeout" toView:self.view];
                    break;
                default:
                    NSLog(@"register.fail");
                    [MBProgressHUD showSuccess:@"register.fail" toView:self.view];
                    break;
            }
        }
        
        BOOL registerSuccess = (!aError) || (aError.code == EMErrorUserAlreadyExist);
        if (registerSuccess) {
            
        }
    }];

    
    
    return ;
    
    
    if (![self isEmpty]) {
        //隐藏键盘
        [self.view endEditing:YES];
        //判断是否是中文，但不支持中英文混编
        if ([self.usernameTextField.text isChinese]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"login.nameNotSupportZh", @"Name does not support Chinese")
                                  message:nil
                                  delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                  otherButtonTitles:nil];
            
            [alert show];
            
            return;
        }
        [self showHudInView:self.view hint:NSLocalizedString(@"register.ongoing", @"Is to register...")];
        __weak typeof(self) weakself = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = [[EMClient sharedClient] registerWithUsername:self.usernameTextField.text password:self.passwordTextField.text];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself hideHud];
                if (!error) {
                    NSLog(@"register.success");
                }else{
                    switch (error.code) {
                        case EMErrorServerNotReachable:
                            NSLog(@"error.connectServerFail");
                            break;
                        case EMErrorUserAlreadyExist:
                            NSLog(@"register.repeat");
                            break;
                        case EMErrorNetworkUnavailable:
                            NSLog(@"error.connectNetworkFail");
                            break;
                        case EMErrorServerTimeout:
                            NSLog(@"error.connectServerTimeout");
                            break;
                        default:
                            NSLog(@"register.fail");
                            break;
                    }
                }
            });
        });
    }
}
- (IBAction)logoutClick:(id)sender {
    
    EMError *error = [[EMClient sharedClient] logout:YES];
        if (!error) {
            [MBProgressHUD showSuccess:@"退出成功" toView:self.view];
            NSLog(@"退出成功");
      }
}

//点击登陆后的操作
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
//    
//    //异步登陆账号
//    __weak typeof(self) weakself = self;
//    [[EMClient sharedClient ] loginWithUsername:self.usernameTextField.text password:self.passwordTextField.text completion:^(NSString *aUsername, EMError *aError) {
//        if (!aError) {
//            MLLog(@"登录成功");
//                [[EMClient sharedClient].options setIsAutoLogin:YES];//自动登录
//            //                    [self sendMessage];
//            [MBProgressHUD showSuccess:@"登录成功"];
//        }else{
//            MLLog(@"aError.code=%d,aError.description=%@",aError.code,aError.errorDescription);
//            NSString *msg = [NSString stringWithFormat:@"登录失败---%@",aError.errorDescription];
//            [MBProgressHUD showSuccess:msg];
//        }
//    }];
//    
//    
//    return ;
    WeakObj(self);
    [self showHudInView:self.view hint:NSLocalizedString(@"login.ongoing", @"Is Login...")];
    //异步登陆账号
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] loginWithUsername:username password:password];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            if (!error) {
                //设置是否自动登录
                [MBProgressHUD showSuccess:@"登录成功" toView:self.view];
                [[EMClient sharedClient].options setIsAutoLogin:YES];
                
                //获取数据库中数据
                [MBProgressHUD showHUDAddedTo:weakself.view animated:YES];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[EMClient sharedClient] migrateDatabaseToLatestSDK];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[ChatDemoHelper shareHelper] asyncGroupFromServer];
                        [[ChatDemoHelper shareHelper] asyncConversationFromDB];
                        [[ChatDemoHelper shareHelper] asyncPushOptions];
                        [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];
                        //发送自动登陆状态通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@([[EMClient sharedClient] isLoggedIn])];
                        
                        //保存最近一次登录用户名
                        [weakself saveLastLoginUsername];
                    });
                });
            } else {
                switch (error.code)
                {
//                    case EMErrorNotFound:
//                        TTAlertNoTitle(error.errorDescription);
//                        break;
                    case EMErrorNetworkUnavailable:{
                        NSLog(@"error.connectNetworkFail");
                        [MBProgressHUD showSuccess:@"error.connectNetworkFail" toView:self.view];
                    }
                        
                        break;
                    case EMErrorServerNotReachable:{
                        NSLog(@"error.connectServerFail");
                        [MBProgressHUD showSuccess:@"error.connectServerFail" toView:self.view];
                    }
                        
                        break;
                    case EMErrorUserAuthenticationFailed:{
                        NSString *msg = error.errorDescription;
                        NSLog(@"msg=%@",msg);
                    }
                        
                        break;
                    case EMErrorServerTimeout:{
                        [MBProgressHUD showSuccess:@"connectServerTimeout" toView:self.view];
                        NSLog(@"error.connectServerTimeout");
                    }
                        
                        break;
                    default:{
                        [MBProgressHUD showSuccess:@"login.fail" toView:self.view];
                        NSLog(@"login.fail");
                    }
                        
                        break;
                }
            }
        });
    });
}

//弹出提示的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView cancelButtonIndex] != buttonIndex) {
        //获取文本输入框
        UITextField *nameTextField = [alertView textFieldAtIndex:0];
        if(nameTextField.text.length > 0)
        {
            //设置推送设置
            [[EMClient sharedClient] setApnsNickname:nameTextField.text];
        }
    }
    //登陆
    [self loginWithUsername:_usernameTextField.text password:_passwordTextField.text];
}

//登陆账号
- (IBAction)doLogin:(id)sender {
    if (![self isEmpty]) {
        [self.view endEditing:YES];
        //支持是否为中文
        if ([self.usernameTextField.text isChinese]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"login.nameNotSupportZh", @"Name does not support Chinese")
                                  message:nil
                                  delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                  otherButtonTitles:nil];
            
            [alert show];
            
            return;
        }
        /*
#if !TARGET_IPHONE_SIMULATOR
        //弹出提示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"login.inputApnsNickname", @"Please enter nickname for apns") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField *nameTextField = [alert textFieldAtIndex:0];
        nameTextField.text = self.usernameTextField.text;
        [alert show];
#elif TARGET_IPHONE_SIMULATOR
        [self loginWithUsername:_usernameTextField.text password:_passwordTextField.text];
#endif
         */
        [self loginWithUsername:_usernameTextField.text password:_passwordTextField.text];
    }
}

//是否使用ip
- (IBAction)useIpAction:(id)sender
{
//    UISwitch *ipSwitch = (UISwitch *)sender;
//    [[EMClient sharedClient].options setEnableDnsConfig:ipSwitch.isOn];
}

//判断账号和密码是否为空
- (BOOL)isEmpty{
    BOOL ret = NO;
    NSString *username = _usernameTextField.text;
    NSString *password = _passwordTextField.text;
    if (username.length == 0 || password.length == 0) {
        ret = YES;
        [EMAlertView showAlertWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                                message:NSLocalizedString(@"login.inputNameAndPswd", @"Please enter username and password")
                        completionBlock:nil
                      cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                      otherButtonTitles:nil];
    }
    
    return ret;
}


#pragma  mark - TextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _usernameTextField) {
        _passwordTextField.text = @"";
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _usernameTextField) {
        [_usernameTextField resignFirstResponder];
        [_passwordTextField becomeFirstResponder];
    } else if (textField == _passwordTextField) {
        [_passwordTextField resignFirstResponder];
        [self doLogin:nil];
    }
    return YES;
}

#pragma  mark - private
- (void)saveLastLoginUsername
{
    NSString *username = [[EMClient sharedClient] currentUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
        [ud synchronize];
    }
}

- (NSString*)lastLoginUsername
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
    if (username && username.length > 0) {
        return username;
    }
    return nil;
}

@end
