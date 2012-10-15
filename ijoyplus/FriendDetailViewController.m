//
//  FriendDetailViewController.m
//  ijoyplus
//
//  Created by joyplus1 on 12-9-25.
//  Copyright (c) 2012年 joyplus. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "CustomBackButtonHolder.h"
#import "CustomBackButton.h"
#import "UIImageView+WebCache.h"
#import "UIUtility.h"
#import "CMConstants.h"


@interface FriendDetailViewController ()

@end

@implementation FriendDetailViewController
@synthesize avatarImageView;
@synthesize titleLabel;
@synthesize subtitleLabel;
@synthesize subtitleNameLabel;
@synthesize titleNameLabel;
@synthesize descriptionLabel;
@synthesize submitBtn;
@synthesize friendInfo;

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
    self.title = NSLocalizedString(@"friend_detail", nil);
    self.titleNameLabel.text = @"姓 名：";
    self.titleLabel.text = [friendInfo valueForKey:@"name"];
    self.subtitleNameLabel.text = @"号 码：";
    self.subtitleLabel.text = [friendInfo valueForKey:@"number"];
    self.descriptionLabel.text = [NSString stringWithFormat:@"您的好友 %@ 还未加入悦+，您可以：", [friendInfo objectForKey:@"name"]];
    [self.avatarImageView setImage:[UIImage imageNamed:@"u2_normal"]];
    self.avatarImageView.layer.cornerRadius = 27.5;
    self.avatarImageView.layer.masksToBounds = YES;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    CustomBackButtonHolder *backButtonHolder = [[CustomBackButtonHolder alloc]initWithViewController:self];
    CustomBackButton* backButton = [backButtonHolder getBackButton:NSLocalizedString(@"go_back", nil)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.submitBtn setTitle:NSLocalizedString(@"sms_invite", nil) forState:UIControlStateNormal];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [UIUtility addTextShadow:submitBtn.titleLabel];
    [self.submitBtn setBackgroundImage:[[UIImage imageNamed:@"log_btn_normal"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [self.submitBtn setBackgroundImage:[[UIImage imageNamed:@"log_btn_active"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
    self.submitBtn.layer.cornerRadius = 10;
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.zPosition = 1;
}

- (void)viewDidUnload
{
    [self setAvatarImageView:nil];
    [self setTitleLabel:nil];
    [self setSubtitleLabel:nil];
    [self setSubtitleNameLabel:nil];
    [self setTitleNameLabel:nil];
    [self setDescriptionLabel:nil];
    [self setSubmitBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)closeSelf
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitBtnClicked:(id)sender {
    BOOL canSendSMS = [MFMessageComposeViewController canSendText];
    NSLog(@"can send SMS [%d]", canSendSMS);
    if (canSendSMS) {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.title = NSLocalizedString(@"new_message", nil);
        picker.messageComposeDelegate = self;
        picker.navigationBar.tintColor = [UIColor blackColor];
        picker.body = NSLocalizedString(@"register_sms_content", nil);
        picker.recipients = [NSArray arrayWithObject:[friendInfo objectForKey:@"number"]];
        [self presentModalViewController:picker animated:YES];
    }

}

#pragma mark SMS delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	
	// Notifies users about errors associated with the interface
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Result: canceled");
			break;
		case MessageComposeResultSent:
			NSLog(@"Result: Sent");
			break;
		case MessageComposeResultFailed:
			NSLog(@"Result: Failed");
			break;
		default:
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}
@end
