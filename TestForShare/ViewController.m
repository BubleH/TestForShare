//
//  ViewController.m
//  TestForShare
//
//  Created by dvt04 on 2017/12/13.
//  Copyright © 2017年 dvt04. All rights reserved.
//

#import "ViewController.h"
#import <Social/Social.h>
#import "TPGActivity.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat originX = 64;
    CGFloat originY = 120;
    CGFloat btnWidth = 220;
    CGFloat btnHeight = 44;
    
    UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnShare setFrame:CGRectMake(originX, originY, btnWidth, btnHeight)];
    [btnShare setBackgroundColor:[UIColor orangeColor]];
    [btnShare setTitle:@"UIActivityViewController分享" forState:UIControlStateNormal];
    [btnShare setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(onHitBtnShare:) forControlEvents:UIControlEventTouchUpInside];
    [btnShare.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:btnShare];

    UIButton *btnWithoutPannel = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnWithoutPannel setFrame:CGRectMake(originX, CGRectGetMaxY(btnShare.frame)+20, btnWidth, btnHeight)];
    [btnWithoutPannel setBackgroundColor:[UIColor greenColor]];
    [btnWithoutPannel setTitle:@"SLComposeViewController分享" forState:UIControlStateNormal];
    [btnWithoutPannel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnWithoutPannel addTarget:self action:@selector(onHitShareWithoutPannel:) forControlEvents:UIControlEventTouchUpInside];
    [btnWithoutPannel.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:btnWithoutPannel];
}

- (void)onHitBtnShare:(id)sender
{
    NSLog(@"onHitBtnShare");
    
    NSString *title = @"分享测试";
    UIImage *image = [UIImage imageNamed:@"testImage"];
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSArray *context = @[title, image, url];
    
    TPGActivity *activity = [[TPGActivity alloc] initWithTitie:title withActivityImage:image withUrl:url withType:@"TPGActivity" withShareContext:context];
    
    /*
    UIKIT_EXTERN UIActivityType const UIActivityTypePostToFacebook     NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED;
    UIKIT_EXTERN UIActivityType const UIActivityTypePostToTwitter      NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED;
    UIKIT_EXTERN UIActivityType const UIActivityTypePostToWeibo        NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED;    // SinaWeibo
    UIKIT_EXTERN UIActivityType const UIActivityTypeMessage            NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED;
    UIKIT_EXTERN UIActivityType const UIActivityTypeMail               NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED;
    UIKIT_EXTERN UIActivityType const UIActivityTypePrint              NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED;
    UIKIT_EXTERN UIActivityType const UIActivityTypeCopyToPasteboard   NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED;
    UIKIT_EXTERN UIActivityType const UIActivityTypeAssignToContact    NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED;
    UIKIT_EXTERN UIActivityType const UIActivityTypeSaveToCameraRoll   NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED;
    UIKIT_EXTERN UIActivityType const UIActivityTypeAddToReadingList   NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED;
    UIKIT_EXTERN UIActivityType const UIActivityTypePostToFlickr       NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED;
    UIKIT_EXTERN UIActivityType const UIActivityTypePostToVimeo        NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED;
    UIKIT_EXTERN UIActivityType const UIActivityTypePostToTencentWeibo NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED;
    UIKIT_EXTERN UIActivityType const UIActivityTypeAirDrop            NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED;
    UIKIT_EXTERN UIActivityType const UIActivityTypeOpenInIBooks       NS_AVAILABLE_IOS(9_0) __TVOS_PROHIBITED;
    UIKIT_EXTERN UIActivityType const UIActivityTypeMarkupAsPDF        NS_AVAILABLE_IOS(11_0) __TVOS_PROHIBITED;
     */
    UIActivityViewController *activityController=[[UIActivityViewController alloc]initWithActivityItems:context applicationActivities:@[activity]];
    activityController.excludedActivityTypes = @[];
    
    //初始化回调方法
    //UIActivityViewControllerCompletionWithItemsHandler)(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError)  iOS >=8.0
    
    //UIActivityViewControllerCompletionHandler (NSString * __nullable activityType, BOOL completed); iOS 6.0~8.0
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
        {
            NSLog(@"activityType :%@", activityType);
            if (completed)
            {
                NSLog(@"completed");
            }
            else
            {
                NSLog(@"cancel");
            }
            
        };
        
        // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
        activityController.completionWithItemsHandler = myBlock;
    }else{
        
        UIActivityViewControllerCompletionHandler myBlock = ^(NSString *activityType,BOOL completed)
        {
            NSLog(@"activityType :%@", activityType);
            if (completed)
            {
                NSLog(@"completed");
            }
            else
            {
                NSLog(@"cancel");
            }
            
        };
        // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
        activityController.completionHandler = myBlock;
    }
    [self presentViewController:activityController animated:YES completion:nil];
}

- (void)onHitShareWithoutPannel:(id)sender
{
    // 来自：http://blog.csdn.net/boyqicheng/article/details/77991765
    
    // Share Extension 分享入口，需要分享到哪个平台就用哪个平台的id
    NSString *socialType = @"com.tencent.xin.sharetimeline";
    /* 1、 系统只提供了下面几种分享平台：
     SLServiceTypeTwitter;
     SLServiceTypeFacebook;
     SLServiceTypeSinaWeibo;
     SLServiceTypeTencentWeibo;
     SLServiceTypeLinkedIn;
     2、iOS8之后系统推出的Share Extension,可以通过App的Share Extension提供了分享入口进行分享如微信的：com.tencent.xin.sharetimeline
     实际可以根据id来分享到更多平台，如微信:
     NSString *socialType = @"com.tencent.xin.sharetimeline";
     SLComposeViewController *composeVC = [SLComposeViewController composeViewControllerForServiceType:socialType];
     //
     3、 下面是小编整理的部分平台id 2017-9-15
     com.taobao.taobao4iphone.ShareExtension  //  淘宝
     com.apple.share.Flickr.post}",   //  Flickr
     com.apple.share.SinaWeibo.post  //   新浪微博
     com.laiwang.DingTalk.ShareExtension  //   钉钉
     com.apple.mobileslideshow.StreamShareService  //  iCloud
     com.alipay.iphoneclient.ExtensionSchemeShare  //   支付宝
     com.apple.share.Facebook.post  //   Facebook
     com.apple.share.Twitter.post  //   Twitter
     com.apple.Health.HealthShareExtension}",    // 应该是健康管理
     com.tencent.xin.sharetimeline  //   微信（好友、朋友圈、收藏）
     com.apple.share.TencentWeibo.post  //   腾讯微博
     com.tencent.mqq.ShareExtension  //   QQ
     */
    
    // 创建 分享的控制器
    SLComposeViewController *composeVC  = [SLComposeViewController composeViewControllerForServiceType:socialType];
    if (!composeVC) {
        NSLog(@"未安装软件");
        return;
    }
    //添加分享的文字、图片、链接
    [composeVC setInitialText:@"哈罗大家好，这是分享测试的内容哦，如已看请忽略！如有任何疑问可联系1008611查你话费吧！"];
    [composeVC addImage:[UIImage imageNamed:@"动态(1)@2x.png"]];
    [composeVC addURL:[NSURL URLWithString:@"http://blog.csdn.net/Boyqicheng"]];
    
    //弹出分享控制器
    [self presentViewController:composeVC animated:YES completion:nil];
    
    //监听用户点击了取消还是发送
    composeVC.completionHandler = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled) {
            NSLog(@"点击了取消");
        } else {
            NSLog(@"点击了发送");
        }
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
