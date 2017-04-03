//
//  CaseToolBarView.m
//  KeyBoardTest2
//
//  Created by LYY on 2017/3/28.
//  Copyright © 2017年 iflytek. All rights reserved.
//

#import "CaseToolBarView.h"
#import "CaseKeyBoardViewController.h"
#define kScreenHeight CGRectGetHeight([[UIScreen mainScreen] bounds])
#define kScreenWidth  CGRectGetWidth([[UIScreen mainScreen] bounds])

@interface CaseToolBarView () <UITextViewDelegate, ZJKeyBoardDelegate>
@property (nonatomic, strong) CaseKeyBoardViewController *keyBoard;
@property (nonatomic, strong) UIScrollView *scrollToolView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation CaseToolBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    [self initInputToolBar];
    return self;
}

- (void)initInputToolBar {
    
//    CGFloat buttonNum = 8;
//    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth * 0.8, 35.5)];
    self.textView = [[UITextView alloc] init];
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.delegate = self;
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.textView];
    
    self.scrollToolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - kScreenWidth/self.lineKeyNumber, kScreenWidth, kScreenWidth/self.lineKeyNumber)];
    [self addSubview:self.scrollToolView];
    
    NSInteger i = 0;
    for (NSString *key in self.toolsArray) {
        UIButton *keyBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/self.lineKeyNumber * i, 0, kScreenWidth/self.lineKeyNumber, kScreenWidth/self.lineKeyNumber)];
        [self.scrollToolView addSubview:keyBtn];
        [keyBtn setTitle:key forState:UIControlStateNormal];
        [keyBtn addTarget:self action:@selector(keyClick:) forControlEvents:UIControlEventTouchUpInside];
        i++;
    }
    
    [self addSubview:self.sendButton];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_scrollToolView(==tvWidth)]-0-|" options:NSLayoutFormatAlignAllLeft metrics:@{@"tvWidth":@(kScreenWidth)} views:@{@"_scrollToolView":self.scrollToolView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_scrollToolView(==tvWidth)]-0-|" options:0 metrics:@{@"tvWidth":@(kScreenWidth/self.lineKeyNumber)} views:@{@"_textView":self.textView,@"_scrollToolView":self.scrollToolView}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_sendButton(==40)]-5-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{@"_sendButton":self.sendButton}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_sendButton(==40)]-5-[_scrollToolView]|" options:0 metrics:nil views:@{@"_sendButton":self.sendButton,@"_scrollToolView":self.scrollToolView}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_textView(==tvWidth)]" options:NSLayoutFormatAlignAllLeft metrics:@{@"tvWidth":@(kScreenWidth * 0.8)} views:@{@"_textView":self.textView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_textView(>=35)]-5-[_scrollToolView]|" options:0 metrics:nil views:@{@"_textView":self.textView,@"_scrollToolView":self.scrollToolView}]];
    
    
    
    [self keyboardObserve];
}

- (void)keyClick:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"X"]) {
        sender.selected = !sender.selected;
        if (sender.selected) {
            [self key_KeyBoardWillHidden];
        } else {
            [self key_KeyBoardWillShow];
        }
        
    }
}

- (void)key_KeyBoardWillHidden {
    self.textView.inputView = nil;
    [self.textView reloadInputViews];
}

- (void)key_KeyBoardWillShow {
    self.textView.inputView = self.keyBoard;
    [self.textView reloadInputViews];
}

- (void)key_KeyBoardSelect:(NSString *)keyValue {
    
    [self.textView insertText:keyValue];
}

-(void)textViewDidChange:(UITextView *)textView{
   
//    static CGFloat maxHeight =60.0f;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    
    if (size.height <= frame.size.height) {
        //        size.height = frame.size.height;
    }else{
        if (size.height >= self.textViewMaxHeight)
        {
            size.height = self.textViewMaxHeight;
            textView.scrollEnabled = YES;   // 允许滚动
        }
        else
        {
            textView.scrollEnabled = NO;    // 不允许滚动
        }
    }
    
//    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    
    CGRect viewFrame = self.frame;
    viewFrame.size.height = viewFrame.size.height + (size.height - frame.size.height);
    viewFrame.origin.y = viewFrame.origin.y - ((size.height - frame.size.height));
    self.frame = viewFrame;

    
    self.scrollToolView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - kScreenWidth/8, kScreenWidth, kScreenWidth/8);
}

- (void)keyboardObserve {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardChange:)
                                                name:UIKeyboardDidChangeFrameNotification
                                              object:nil];
}

#pragma mark - 键盘处理
- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSLog(@"keyboardWillShow");
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSValue *rectValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    CGRect keyBoardFrame = [rectValue CGRectValue];
    
    NSLog(@"%@",NSStringFromCGRect(keyBoardFrame));
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         
                         self.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(keyBoardFrame));
                         
                     }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSLog(@"keyboardWillHide");
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         
                         
                     }];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    
    
    NSLog(@"keyboardDidHide");
}

- (void)keyboardChange:(NSNotification *)notification {
    
    NSLog(@"keyboard Change");
    
}


- (NSArray *)toolsArray {
    if (!_toolsArray) {
        _toolsArray = @[@"X",@".",@"/",@",",@"`",@"!",@"@",@"*"];
    }
    return _toolsArray;
}

- (CaseKeyBoardViewController *)keyBoard {
    if (!_keyBoard) {
        _keyBoard = [[CaseKeyBoardViewController alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
        _keyBoard.delegate = self;
    }
    return _keyBoard;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [[UIButton alloc] init];
        [_sendButton setBackgroundColor:[UIColor redColor]];
        _sendButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _sendButton;
}

- (CGFloat)textViewMaxHeight {
     if(_textViewMaxHeight == 0) {
         _textViewMaxHeight = 60;
        return _textViewMaxHeight;
    }
    return _textViewMaxHeight;
    
}

- (CGFloat)lineKeyNumber {
    if (_lineKeyNumber == 0) {
        _lineKeyNumber = 8;
        }
    return _lineKeyNumber;
}


@end
