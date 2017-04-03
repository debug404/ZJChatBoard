//
//  CaseToolBarView.h
//  KeyBoardTest2
//
//  Created by LYY on 2017/3/28.
//  Copyright © 2017年 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseToolBarView : UIView
@property (nonatomic,assign)CGFloat textViewMaxHeight;//动态输入框最大高度，默认为60
@property (nonatomic, strong)NSArray *toolsArray;//工具条按钮

@property (nonatomic,assign)CGFloat lineKeyNumber;//每行显示的按钮数量

@end
