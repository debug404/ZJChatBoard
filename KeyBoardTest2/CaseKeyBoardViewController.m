//
//  CaseKeyBoardViewController.m
//  KeyBoardTest
//
//  Created by LYY on 2017/3/24.
//  Copyright © 2017年 iflytek. All rights reserved.
//

#import "CaseKeyBoardViewController.h"
#import "KeyBoardCell.h"


static NSString *identifer = @"KeyBoardCell";
#define TOOLBAR_HEIGHT 0
@interface CaseKeyBoardViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, NSXMLParserDelegate>
@property (nonatomic)UICollectionView *collectionView;
@property (nonatomic)NSMutableArray *keysArray;
@property (nonatomic)UIView *toolBar;
@end

@implementation CaseKeyBoardViewController


- (instancetype)initWithFrame:(CGRect)frame {
    self =  [super initWithFrame:frame];
    
    [self readXMLData];
    return self;
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.keysArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KeyBoardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
    
    cell.keyLabel.text = self.keysArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *keyValue = self.keysArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(key_KeyBoardSelect:)]) {
        [self.delegate key_KeyBoardSelect:keyValue];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kScreenWidth / 6, kScreenWidth / 6);
    
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return  0.0f;
}



- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, TOOLBAR_HEIGHT, kScreenWidth, CGRectGetHeight(self.frame) - TOOLBAR_HEIGHT) collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"KeyBoardCell" bundle:nil] forCellWithReuseIdentifier:identifer];
    
        
    }
    return _collectionView;
}


- (void)readXMLData {
    NSString *xmlPath = [[NSBundle mainBundle] pathForResource:@"KeyBoardChars.xml" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:xmlPath];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    xmlParser.delegate = self;
    [xmlParser parse];
    
}


# pragma mark - 协议方法

// 开始
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    
    NSLog(@"开始");
    
}

// 获取节点头
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    NSLog(@"start element : %@", elementName);
    
}

// 获取节点的值 (这个方法在获取到节点头和节点尾后，会分别调用一次)
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![string isEqualToString:@""]) {
        [self.keysArray addObject:string];
    }

}

// 获取节点尾
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    NSLog(@"end element :%@", elementName);
}

// 结束
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    NSLog(@"结束");
    [self addSubview:self.toolBar];
    [self addSubview:self.collectionView];
    
}

- (NSMutableArray *)keysArray {
    if (!_keysArray) {
        _keysArray = [NSMutableArray array];
    }
    return _keysArray;
}

- (UIView *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TOOLBAR_HEIGHT)];
        [_toolBar setBackgroundColor:[UIColor redColor]];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
        [btn setTitle:@"X" forState:UIControlStateNormal];
        [_toolBar addSubview:btn];
        [btn addTarget:self action:@selector(hiddenKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toolBar;
}

- (void)hiddenKeyBoard {
    if ([self.delegate respondsToSelector:@selector(key_KeyBoardWillHidden)]) {
        [self.delegate key_KeyBoardWillHidden];
    }
}


@end
