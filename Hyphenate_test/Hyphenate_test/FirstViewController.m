//
//  FirstViewController.m
//  Hyphenate_test
//
//  Created by Sunny Zhang on 16/10/17.
//  Copyright © 2016年 ZhaiJia. All rights reserved.
//

#import "FirstViewController.h"
#import "ChatViewController.h"
#import "LoginViewController.h"

@interface FirstViewController ()

@property (weak, nonatomic) IBOutlet UITextField *sellerWangId;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)contactSeller:(id)sender {
    
    BOOL isAutoLogin = [EMClient sharedClient].isAutoLogin;
    if (isAutoLogin) {
        NSString *sellerWangWangID = self.sellerWangId.text;
        ChatViewController *chatController  = nil;
        chatController = [[ChatViewController alloc] initWithConversationChatter:sellerWangWangID conversationType:EMConversationTypeChat];
        chatController.title = @"聊天";
        
        [self.navigationController pushViewController:chatController animated:YES];
    }else{
        LoginViewController *loginVc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:loginVc animated:YES];
        
    }
    
    
}

@end
