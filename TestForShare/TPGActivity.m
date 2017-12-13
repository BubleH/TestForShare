//
//  TPGActivity.m
//  TestForShare
//
//  Created by dvt04 on 2017/12/13.
//  Copyright © 2017年 dvt04. All rights reserved.
//

#import "TPGActivity.h"

@implementation TPGActivity


- (instancetype)initWithTitie:(NSString *)title withActivityImage:(UIImage *)image withUrl:(NSURL *)url withType:(NSString *)type withShareContext:(NSArray *)shareContexts
{
    _title = title;
    _image = image;
    _url = url;
    _type = type;
    _shareContexts = shareContexts;
    
    return self;
}

- (NSString *)activityTitle
{
    return _title;
}

- (UIImage *)activityImage
{
    return _image;
}

+ (UIActivityCategory)activityCategory
{
    // 决定在UIActivityViewController中显示的位置，最上面是AirDrop，中间是Share，下面是Action
    return UIActivityCategoryShare;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    //准备分享所进行的方法，通常在这个方法里面，把item中的东西保存下来,items就是要传输的数据
    NSLog(@"wowowowowowowow");
}

- (void)performActivity
{
    //用safari打开网址
    if ([[UIDevice currentDevice].systemVersion floatValue] > 10.0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.baidu.com"] options:nil completionHandler:^(BOOL success) {
            //这里就可以关联外面的app进行分享操作了
            //也可以进行一些数据的保存等操作
            //操作的最后必须使用下面方法告诉系统分享结束了
            [self activityDidFinish:YES];
        }];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    }

}

@end
