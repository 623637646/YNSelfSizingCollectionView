//
//  YNDemoViewController.m
//  YNSelfSizingCollectionViewDemo
//
//  Created by wangya on 2018/1/26.
//  Copyright © 2018年 Yanni. All rights reserved.
//

#import "YNDemoViewController.h"
#import "YNSelfSizingCollectionView.h"
#import "YNDemoAutoLayoutFixedWidthCollectionViewCell.h"
#import "YNDemoAutoLayoutFixedWidthAndHeightCollectionViewCell.h"
#import "YNDemoAutoLayoutFixedHeightCollectionViewCell.h"
#import "YNDemoFrameLayoutFixedWidthCollectionViewCell.h"
#import "YNDemoFrameLayoutFixedWidthAndHeightCollectionViewCell.h"
#import "YNDemoFrameLayoutFixedHeightCollectionViewCell.h"
#import "YNDemoTitleCollectionReusableView.h"

@interface YNDemoViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray<NSDictionary*> *data;
@end

@implementation YNDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray<NSDictionary*> *data = [NSMutableArray<NSDictionary*> array];
    for (int i = 0; i < 3; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        switch (i) {
            case 0:{
                [dic setObject:@"fixed width and height" forKey:@"title"];
                break;
            }
            case 1:{
                [dic setObject:@"fixed width" forKey:@"title"];
                break;
            }
            case 2:{
                [dic setObject:@"fixed height" forKey:@"title"];
                break;
            }
            default:
                break;
        }
        NSMutableArray *insideData = [NSMutableArray array];
        for (int j = 0; j < 9; j++) {
            [insideData addObject:({
                NSMutableString *string = [NSMutableString string];
                for (int i=0; i<arc4random_uniform(30) + 1; i++) {
                    [string appendFormat:@"%@",@(i)];
                }
                string;
            })];
        }
        [dic setObject:insideData forKey:@"data"];
        [data addObject:dic];
    }
    self.data = data;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    YNSelfSizingCollectionView *collectionView = [[YNSelfSizingCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [collectionView registerClass:YNDemoTitleCollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[YNDemoTitleCollectionReusableView description]];
    [collectionView registerClass:YNDemoAutoLayoutFixedWidthAndHeightCollectionViewCell.class forCellWithReuseIdentifier:[YNDemoAutoLayoutFixedWidthAndHeightCollectionViewCell description]];
    [collectionView registerClass:YNDemoAutoLayoutFixedWidthCollectionViewCell.class forCellWithReuseIdentifier:[YNDemoAutoLayoutFixedWidthCollectionViewCell description]];
    [collectionView registerClass:YNDemoAutoLayoutFixedHeightCollectionViewCell.class forCellWithReuseIdentifier:[YNDemoAutoLayoutFixedHeightCollectionViewCell description]];
    [collectionView registerClass:YNDemoFrameLayoutFixedWidthAndHeightCollectionViewCell.class forCellWithReuseIdentifier:[YNDemoFrameLayoutFixedWidthAndHeightCollectionViewCell description]];
    [collectionView registerClass:YNDemoFrameLayoutFixedWidthCollectionViewCell.class forCellWithReuseIdentifier:[YNDemoFrameLayoutFixedWidthCollectionViewCell description]];
    [collectionView registerClass:YNDemoFrameLayoutFixedHeightCollectionViewCell.class forCellWithReuseIdentifier:[YNDemoFrameLayoutFixedHeightCollectionViewCell description]];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
}

-(BOOL) isUseFrameCell{
    return [self.tabBarController.viewControllers indexOfObject:self] == 0;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.data.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[[self.data objectAtIndex:section] objectForKey:@"data"] count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YNSelfSizingCollectionViewCell *cell = nil;
    if ([self isUseFrameCell]) {
        switch (indexPath.section) {
            case 0:{
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YNDemoFrameLayoutFixedWidthAndHeightCollectionViewCell description] forIndexPath:indexPath];
                ((YNDemoFrameLayoutFixedWidthAndHeightCollectionViewCell*)cell).title = [[[self.data objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
                break;
            }
            case 1:{
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YNDemoFrameLayoutFixedWidthCollectionViewCell description] forIndexPath:indexPath];
                ((YNDemoFrameLayoutFixedWidthCollectionViewCell*)cell).title = [[[self.data objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
                break;
            }
            case 2:{
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YNDemoFrameLayoutFixedHeightCollectionViewCell description] forIndexPath:indexPath];
                ((YNDemoFrameLayoutFixedHeightCollectionViewCell*)cell).title = [[[self.data objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
                break;
            }
            default:
                break;
        }
    }else{
        switch (indexPath.section) {
            case 0:{
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YNDemoAutoLayoutFixedWidthAndHeightCollectionViewCell description] forIndexPath:indexPath];
                ((YNDemoAutoLayoutFixedWidthAndHeightCollectionViewCell*)cell).title = [[[self.data objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
                break;
            }
            case 1:{
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YNDemoAutoLayoutFixedWidthCollectionViewCell description] forIndexPath:indexPath];
                ((YNDemoAutoLayoutFixedWidthCollectionViewCell*)cell).title = [[[self.data objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
                break;
            }
            case 2:{
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YNDemoAutoLayoutFixedHeightCollectionViewCell description] forIndexPath:indexPath];
                ((YNDemoAutoLayoutFixedHeightCollectionViewCell*)cell).title = [[[self.data objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
                break;
            }
            default:
                break;
        }
    }
    cell.backgroundColor = ({
        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        color;
    });
    return cell;
}

- (CGSize)collectionView:(YNSelfSizingCollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeZero;
    if ([self isUseFrameCell]) {
        switch (indexPath.section) {
            case 0:{
                size = [collectionView sizeForCellWithIdentifier:[YNDemoFrameLayoutFixedWidthAndHeightCollectionViewCell description] indexPath:indexPath configuration:^(YNDemoFrameLayoutFixedWidthAndHeightCollectionViewCell *cell) {
                    cell.title = [[[self.data objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
                }];
                break;
            }
            case 1:{
                size = [collectionView sizeForCellWithIdentifier:[YNDemoFrameLayoutFixedWidthCollectionViewCell description] indexPath:indexPath configuration:^(YNDemoFrameLayoutFixedWidthCollectionViewCell *cell) {
                    cell.title = [[[self.data objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
                }];
                break;
            }
            case 2:{
                size = [collectionView sizeForCellWithIdentifier:[YNDemoFrameLayoutFixedHeightCollectionViewCell description] indexPath:indexPath configuration:^(YNDemoFrameLayoutFixedHeightCollectionViewCell *cell) {
                    cell.title = [[[self.data objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
                }];
                break;
            }
            default:
                break;
        }
    }else{
        switch (indexPath.section) {
            case 0:{
                size = [collectionView sizeForCellWithIdentifier:[YNDemoAutoLayoutFixedWidthAndHeightCollectionViewCell description] indexPath:indexPath configuration:^(YNDemoAutoLayoutFixedWidthAndHeightCollectionViewCell *cell) {
                    cell.title = [[[self.data objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
                }];
                break;
            }
            case 1:{
                size = [collectionView sizeForCellWithIdentifier:[YNDemoAutoLayoutFixedWidthCollectionViewCell description] indexPath:indexPath configuration:^(YNDemoAutoLayoutFixedWidthCollectionViewCell *cell) {
                    cell.title = [[[self.data objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
                }];
                break;
            }
            case 2:{
                size = [collectionView sizeForCellWithIdentifier:[YNDemoAutoLayoutFixedHeightCollectionViewCell description] indexPath:indexPath configuration:^(YNDemoAutoLayoutFixedHeightCollectionViewCell *cell) {
                    cell.title = [[[self.data objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
                }];
                break;
            }
            default:
                break;
        }
    }
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        YNDemoTitleCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[YNDemoTitleCollectionReusableView description] forIndexPath:indexPath];
        headerView.title = [[self.data objectAtIndex:indexPath.section] objectForKey:@"title"];
        return headerView;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.bounds.size.width, 44);
}

@end
