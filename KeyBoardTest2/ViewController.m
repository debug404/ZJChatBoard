//
//  ViewController.m
//  KeyBoardTest2
//
//  Created by LYY on 2017/3/24.
//  Copyright © 2017年 iflytek. All rights reserved.
//

#import "ViewController.h"
#import "CaseToolBarView.h"
#import "CaseKeyBoardViewController.h"

@interface ViewController ()<ZJKeyBoardDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (nonatomic, strong)NSArray *toolsArray;
@property (nonatomic,strong)UIView *toolBarView;

@property (nonatomic, strong) CaseKeyBoardViewController *keyBoard;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CaseToolBarView *toolBar = [[CaseToolBarView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 90, kScreenWidth, 90)];
    [toolBar setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:toolBar];
    
}

- (void)initInputToolBar {
    
    CGFloat toolBarHeight = 100;
    CGFloat buttonNum = 8;
    CGFloat buttonWidth = 50;
    CGFloat buttonHeight = 40;
   
    self.toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - toolBarHeight, kScreenWidth, toolBarHeight)];
    [self.toolBarView setBackgroundColor:[UIColor blueColor]];
     [self.view addSubview:self.toolBarView];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth - buttonWidth, 35.5)];
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.delegate = self;
    [self.toolBarView addSubview:self.textView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, toolBarHeight - kScreenWidth/buttonNum, kScreenWidth, 50)];
    
    [self.toolBarView addSubview:scrollView];
    NSInteger i = 0;
    for (NSString *key in self.toolsArray) {
        UIButton *keyBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/buttonNum * i, 0, kScreenWidth/buttonNum, kScreenWidth/buttonNum)];
        [scrollView addSubview:keyBtn];
        [keyBtn setTitle:key forState:UIControlStateNormal];
        [keyBtn addTarget:self action:@selector(keyClick:) forControlEvents:UIControlEventTouchUpInside];
        i++;
    }
    
    
}

-(void)textViewDidChange:(UITextView *)textView{
    //博客园-FlyElephant
    static CGFloat maxHeight =60.0f;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    NSLog(@"old  size ----- %@",NSStringFromCGSize(size));
    NSLog(@"frame.size  ----- %@",NSStringFromCGSize(frame.size));

    if (size.height <= frame.size.height) {
//        size.height = frame.size.height;
    }else{
        if (size.height >= maxHeight)
        {
            size.height = maxHeight;
            textView.scrollEnabled = YES;   // 允许滚动
        }
        else
        {
            textView.scrollEnabled = NO;    // 不允许滚动
        }
    }
    
    
    NSLog(@"size ----- %@",NSStringFromCGSize(size));
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
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
    self.textField.inputView = nil;
    [self.textField reloadInputViews];
    
    self.textView.inputView = nil;
    [self.textView reloadInputViews];
}

- (void)key_KeyBoardWillShow {
    self.textField.inputView = self.keyBoard;
    [self.textField reloadInputViews];
    
    self.textView.inputView = self.keyBoard;
    [self.textView reloadInputViews];
}



- (void)key_KeyBoardSelect:(NSString *)keyValue {
    NSLog(@"%@",keyValue);
    [self.textField insertText:keyValue];
}

- (void)keyboardDidShow:(NSNotification *)notification{
  
    
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
                         
                         self.toolBarView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(keyBoardFrame));
                         
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
