//
//  CaseKeyBoardViewController.h
//  KeyBoardTest
//
//  Created by LYY on 2017/3/24.
//  Copyright © 2017年 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZJKeyBoardDelegate <NSObject>

- (void)key_KeyBoardSelect:(NSString *)keyValue;
- (void)key_KeyBoardWillHidden;

@end

#define kScreenHeight CGRectGetHeight([[UIScreen mainScreen] bounds])
#define kScreenWidth  CGRectGetWidth([[UIScreen mainScreen] bounds])
@interface CaseKeyBoardViewController : UIView

@property (nonatomic,weak)id<ZJKeyBoardDelegate> delegate;

@end
