//
//  TPGActivity.h
//  TestForShare
//
//  Created by dvt04 on 2017/12/13.
//  Copyright © 2017年 dvt04. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPGActivity : UIActivity

@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, strong) NSURL * url;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, strong) NSArray * shareContexts;

- (instancetype)initWithTitie:(NSString *)title withActivityImage:(UIImage *)image withUrl:(NSURL *)url withType:(NSString *)type withShareContext:(NSArray *)shareContexts;

@end
