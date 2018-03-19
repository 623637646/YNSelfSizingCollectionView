//
//  YNSelfSizingCollectionView.m
//  YNSelfSizingCollectionView
//
//  Created by wangya on 2018/1/26.
//  Copyright © 2018年 Yanni. All rights reserved.
//

#import "YNSelfSizingCollectionView.h"

@interface YNSelfSizingCollectionView()
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath*, NSValue*> *sizeCache;
@property (nonatomic, strong) NSMutableDictionary<NSString*, YNSelfSizingCollectionViewCell*> *templeCells;
@end

@implementation YNSelfSizingCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.sizeCache = [NSMutableDictionary<NSIndexPath*, NSValue*> dictionary];
        self.templeCells = [NSMutableDictionary<NSString*, YNSelfSizingCollectionViewCell*> dictionary];
    }
    return self;
}

#pragma mark - overwrite

-(void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier{
    [super registerNib:nib forCellWithReuseIdentifier:identifier];
    id cell = [[nib instantiateWithOwner:nil options:nil] lastObject];
    if (cell && [cell isKindOfClass:YNSelfSizingCollectionViewCell.class]) {
        ((YNSelfSizingCollectionViewCell*)cell).isTestCell = YES;
        [self.templeCells setObject:cell forKey:identifier];
    }
}

-(void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier{
    [super registerClass:cellClass forCellWithReuseIdentifier:identifier];
    id cell = [[cellClass alloc] initWithFrame:CGRectZero];
    if (cell && [cell isKindOfClass:YNSelfSizingCollectionViewCell.class]) {
        ((YNSelfSizingCollectionViewCell*)cell).isTestCell = YES;
        [self.templeCells setObject:cell forKey:identifier];
    }
}

-(void)reloadData{
    [super reloadData];
    [self invalidateCache];
}



#pragma mark - public

- (CGSize)sizeForCellWithIdentifier:(NSString *)identifier
                          indexPath:(NSIndexPath *)indexPath
                      configuration:(void (^)(__kindof YNSelfSizingCollectionViewCell *))configuration{
    if ([self.sizeCache.allKeys containsObject:indexPath]) {
        return [[self.sizeCache objectForKey:indexPath] CGSizeValue];
    }
    
    // has no size chche
    YNSelfSizingCollectionViewCell *cell = [self.templeCells objectForKey:identifier];
    NSAssert(cell, @"cell is nil");
    configuration(cell);
    [cell.contentView setNeedsUpdateConstraints];
    [cell.contentView setNeedsLayout];
    [cell.contentView updateConstraintsIfNeeded];
    [cell.contentView layoutIfNeeded];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    size = [self fixSize:size];
    NSValue *sizeValue = [NSValue valueWithCGSize:size];
    [self.sizeCache setObject:sizeValue forKey:indexPath];
    return size;
}

-(void)invalidateCache{
    [[self sizeCache] removeAllObjects];
}

#pragma mark - private

-(CGSize)fixSize:(CGSize)size{
    return CGSizeMake([self fixFloat:size.width], [self fixFloat:size.height]);
}

-(CGFloat)fixFloat:(CGFloat)number{
    NSInteger interNumber = number;
    CGFloat diff = number - interNumber;
    diff = diff < 0.5f ? 0 : 0.5f;
    return interNumber + diff;
}

@end
