//
//  IphoneSettingViewController.m
//  yueshipin
//
//  Created by 08 on 12-12-26.
//  Copyright (c) 2012年 joyplus. All rights reserved.
//

#import "IphoneSettingViewController.h"
#import "FeedBackViewController.h"
#import "AboutViewController.h"
#import "StatementsViewController.h"
#import "MBProgressHUD.h"
#import "SDImageCache.h"
#import "Reachability.h"
#import "UIUtility.h"
#import "ContainerUtility.h"
#import "AppDelegate.h"
#import "CMConstants.h"
#import "AFServiceAPIClient.h"
#import "ServiceConstants.h"
#import "UIImage+Scale.h"
#import "AFSinaWeiboAPIClient.h"

@interface IphoneSettingViewController ()

@end

@implementation IphoneSettingViewController
@synthesize sinaSwith = sinaSwith_;
@synthesize sinaweibo = sinaweibo_;

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
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 40, 30);
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setImage:[UIImage scaleFromImage:[UIImage imageNamed:@"top_return_common.png"] toSize:CGSizeMake(20, 18)] forState:UIControlStateNormal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_common.png"]];
    bg.frame = CGRectMake(0, 0, 320, 480);
    [self.view addSubview:bg];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(12, 17, 296, 59)];
    view1.backgroundColor = [UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha: 1.0f];;
    UIImageView *sinaWeibo = [[UIImageView alloc] initWithFrame:CGRectMake(12, 13, 272, 33)];
    sinaWeibo.image = [UIImage imageNamed:@"my_s_xinlang.png"];
    [view1 addSubview:sinaWeibo];
    sinaSwith_ = [[UISwitch alloc] initWithFrame:CGRectMake(200, 16, 50, 22)];
    [sinaSwith_ addTarget:self action:@selector(sinaSwitchClicked:) forControlEvents:UIControlEventValueChanged];
    [view1 addSubview:sinaSwith_];
    
    sinaweibo_ = [AppDelegate instance].sinaweibo;
    sinaweibo_.delegate = self;
    if([sinaweibo_ isLoggedIn]){
        sinaSwith_.on = YES;
        //NSString *username = (NSString *)[[ContainerUtility sharedInstance] attributeForKey:kUserNickName];
    }

    [self.view addSubview:view1];
   
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(12, 86, 296, 59)];
    view2.backgroundColor = [UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha: 1.0f];
    [self.view addSubview:view2];
    
    UIButton *clearCache = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    clearCache.frame = CGRectMake(24, 100, 273, 33);
    // [feedBack setTitle:@"意见反馈" forState:UIControlStateNormal];
    [clearCache setBackgroundImage:[UIImage imageNamed:@"my_setting_cache.png"] forState:UIControlStateNormal];
    [clearCache setBackgroundImage:[UIImage imageNamed:@"my_setting_cache_s.png"] forState:UIControlStateHighlighted];
    [clearCache addTarget:self action:@selector(clearCache:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearCache];
    
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(12, 155, 296, 172)];
    view3.backgroundColor = [UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha: 1.0f];;
    [self.view addSubview:view3];
    UIButton *feedBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    feedBack.frame = CGRectMake(24, 168, 273, 33);
   // [feedBack setTitle:@"意见反馈" forState:UIControlStateNormal];
    [feedBack setBackgroundImage:[UIImage imageNamed:@"my_setting_other.png"] forState:UIControlStateNormal];
    [feedBack setBackgroundImage:[UIImage imageNamed:@"my_setting_other_s.png"] forState:UIControlStateHighlighted];
    [feedBack addTarget:self action:@selector(feedBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:feedBack];
    
    UIButton *suggest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    suggest.frame = CGRectMake(24, 208, 273, 33);
    //[suggest setTitle:@"免责声明" forState:UIControlStateNormal];
    [suggest setBackgroundImage:[UIImage imageNamed:@"my_setting_other4.png"] forState:UIControlStateNormal];
    [suggest setBackgroundImage:[UIImage imageNamed:@"my_setting_other4_s.png"] forState:UIControlStateHighlighted];
    [suggest addTarget:self action:@selector(suggest:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:suggest];
    
    UIButton *aboutUs = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    aboutUs.frame = CGRectMake(24, 286, 273, 33);
    //[aboutUs setTitle:@"关于我们" forState:UIControlStateNormal];
    [aboutUs setBackgroundImage:[UIImage imageNamed:@"my_setting_other2.png"] forState:UIControlStateNormal];
    [aboutUs setBackgroundImage:[UIImage imageNamed:@"my_setting_other2_s.png"] forState:UIControlStateHighlighted];
    [aboutUs addTarget:self action:@selector(aboutUs:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aboutUs];
    
    UIButton *careUs = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    careUs.frame = CGRectMake(24, 247, 273, 33);
    [careUs setBackgroundImage:[UIImage imageNamed:@"my_setting_other3.png"] forState:UIControlStateNormal];
    [careUs setBackgroundImage:[UIImage imageNamed:@"my_setting_other3_s.png"] forState:UIControlStateHighlighted];
    [careUs addTarget:self action:@selector(careUs:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:careUs];
	// Do any additional setup after loading the view.
}

-(void)back:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)careUs:(id)sender{
    sinaweibo_ = [AppDelegate instance].sinaweibo;
    if([sinaweibo_ isLoggedIn]){
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:sinaweibo_.accessToken, @"access_token", @"悦视频", @"screen_name", nil];
        [[AFSinaWeiboAPIClient sharedClient] postPath:kFollowUserURI parameters:parameters success:^(AFHTTPRequestOperation *operation, id result) {
            
        } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
        }];
        [self showSuccessModalView:1.5];
    } else {
        NSURL *url=[NSURL URLWithString:@"http://weibo.com/u/3058636171"];
        [[UIApplication sharedApplication] openURL:url];
    }


}
- (void)showSuccessModalView:(int)closeTime
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)];
    view.tag = 3268142;
    [view setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
    UIImageView *temp = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"success_img"]];
    temp.frame = CGRectMake(0, 0, 324, 191);
    temp.center = view.center;
    [view addSubview:temp];
    [self.view addSubview:view];
    [NSTimer scheduledTimerWithTimeInterval:closeTime target:self selector:@selector(removeOverlay) userInfo:nil repeats:NO];
}

- (void)removeOverlay
{
    UIView *view = (UIView *)[self.view viewWithTag:3268142];
    for(UIView *subview in view.subviews){
        [subview removeFromSuperview];
    }
    [view removeFromSuperview];
    view = nil;
}

- (void)sinaSwitchClicked:(UISwitch *)sender
{
    Reachability *hostReach = [Reachability reachabilityForInternetConnection];
    if([hostReach currentReachabilityStatus] == NotReachable) {
        [UIUtility showNetWorkError:self.view];
        return;
    }
    BOOL flag = sender.isOn;
    if(flag){
        [sinaweibo_ logIn];
    } else {
        [sinaweibo_ logOut];
    }
}

-(void)clearCache:(id)sender{

    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"正在清理...";
    [HUD showWhileExecuting:@selector(clearCache) onTarget:self withObject:nil animated:YES];
    
}

- (void)clearCache
{
    [[SDImageCache sharedImageCache] clearDisk];
    sleep(1);
}
-(void)feedBack:(id)sender{
    FeedBackViewController *feedBackViewController = [[FeedBackViewController alloc] init];
    [self.navigationController pushViewController:feedBackViewController animated:YES];

}

-(void)suggest:(id)sender{
    StatementsViewController *satementViewController = [[StatementsViewController alloc] init];
    [self.navigationController pushViewController:satementViewController animated:YES];
    
}

-(void)aboutUs:(id)sender{
    AboutViewController *aboutViewController = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:aboutViewController animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

- (void)storeAuthData
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo_.accessToken, @"AccessTokenKey",
                              sinaweibo_.expirationDate, @"ExpirationDateKey",
                              sinaweibo_.userID, @"UserIDKey",
                              sinaweibo_.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [self storeAuthData];
    sinaSwith_.on = YES;
    [sinaweibo requestWithURL:@"users/show.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
   
    [self removeAuthData];
    sinaSwith_.on = NO;
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
    sinaSwith_.on = NO;
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
    sinaSwith_.on = NO;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"网络数据错误，请重新登陆。"
                                                       delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [self removeAuthData];
    sinaSwith_.on = NO;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Token已过期，请重新登陆。"
                                                       delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)userInfo
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        NSString *username = [userInfo objectForKey:@"screen_name"];
        [[ContainerUtility sharedInstance] setAttribute:username forKey:kUserNickName];
        
        NSString *avatarUrl = [userInfo objectForKey:@"avatar_large"];
        [[ContainerUtility sharedInstance] setAttribute:avatarUrl forKey:kUserAvatarUrl];
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: [userInfo objectForKey:@"idstr"], @"source_id", @"1", @"source_type", nil];
        [[AFServiceAPIClient sharedClient] postPath:kPathUserValidate parameters:parameters success:^(AFHTTPRequestOperation *operation, id result) {
            NSString *responseCode = [result objectForKey:@"res_code"];
            if(responseCode == nil){
                NSString *user_id = [result objectForKey:@"user_id"];
                [[AFServiceAPIClient sharedClient] setDefaultHeader:@"user_id" value:user_id];
                [[ContainerUtility sharedInstance] setAttribute:user_id forKey:kUserId];
            } else {
                NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: [userInfo objectForKey:@"idstr"], @"source_id", @"1", @"source_type", avatarUrl, @"pic_url", username, @"nickname", nil];
                [[AFServiceAPIClient sharedClient] postPath:kPathAccountBindAccount parameters:parameters success:^(AFHTTPRequestOperation *operation, id result) {
                    
                } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            }
        } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        
        
    }
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        
    }
}

@end
