//
//  YNSelfSizingCollectionView.m
//  YNSelfSizingCollectionView
//
//  Created by wangya on 2018/1/26.
//  Copyright © 2018年 Yanni. All rights reserved.
//

#import "YNSelfSizingCollectionView.h"

CGFloat YNSelfSizingRoundPixelValue(CGFloat value)
{
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(){
        scale = [UIScreen mainScreen].scale;
    });
    
    return roundf(value * scale) / scale;
}

@interface YNSelfSizingCollectionView()
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath*, NSValue*> *sizeCache;
@property (nonatomic, strong) NSMutableDictionary<NSString*, YNSelfSizingCollectionViewCell*> *templeCells;
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSValue*> *fixWidthAndHeightCellValues;
@end

@implementation YNSelfSizingCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.sizeCache = [NSMutableDictionary<NSIndexPath*, NSValue*> dictionary];
        self.templeCells = [NSMutableDictionary<NSString*, YNSelfSizingCollectionViewCell*> dictionary];
        self.fixWidthAndHeightCellValues = [NSMutableDictionary<NSString*, NSValue*> dictionary];
    }
    return self;
}

#pragma mark - overwrite

-(void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier{
    [super registerNib:nib forCellWithReuseIdentifier:identifier];
    // must used registerClass forCellWithReuseIdentifier
    exit(0);
}

-(void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier{
    [super registerClass:cellClass forCellWithReuseIdentifier:identifier];
    if (![cellClass isSubclassOfClass:YNSelfSizingCollectionViewCell.class]) {
        return;
    }
    if ([cellClass selfSizingType] == YNSelfSizingCollectionViewCellTypeFixedWidthAndHeight) {
        CGSize size = CGSizeMake([cellClass fixedWidthWithCollectionView:self], [cellClass fixedHeightWithCollectionView:self]);
        [self.fixWidthAndHeightCellValues setObject:[NSValue valueWithCGSize:size] forKey:identifier];
    }else{
        id cell = [[cellClass alloc] initWithFrame:CGRectZero];
        ((YNSelfSizingCollectionViewCell*)cell).isTestCell = YES;
        ((YNSelfSizingCollectionViewCell*)cell).collectionView = self;
        [self.templeCells setObject:cell forKey:identifier];
    }
}

- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    YNSelfSizingCollectionViewCell *cell = [super dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    ((YNSelfSizingCollectionViewCell*)cell).collectionView = self;
    return cell;
}

#pragma mark - reload data

-(void)reloadData{
    [self.sizeCache removeAllObjects];
    [super reloadData];
}

- (void)reloadSections:(NSIndexSet *)sections {
    NSMutableArray<NSIndexPath*> *needRemove = [NSMutableArray<NSIndexPath*> array];
    for (NSIndexPath *indexPath in self.sizeCache.allKeys) {
        if ([sections containsIndex:indexPath.section]) {
            [needRemove addObject:indexPath];
        }
    }
    [self.sizeCache removeObjectsForKeys:needRemove];
    [super reloadSections:sections];
}

- (void)deleteSections:(NSIndexSet *)sections {
    NSMutableArray<NSIndexPath*> *needRemove = [NSMutableArray<NSIndexPath*> array];
    for (NSIndexPath *indexPath in self.sizeCache.allKeys) {
        if ([sections containsIndex:indexPath.section]) {
            [needRemove addObject:indexPath];
        }
    }
    [self.sizeCache removeObjectsForKeys:needRemove];
    [super deleteSections:sections];
}

- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection {
    NSMutableArray<NSIndexPath*> *needMove = [NSMutableArray<NSIndexPath*> array];
    NSMutableArray<NSIndexPath*> *needMoveNew = [NSMutableArray<NSIndexPath*> array];
    for (NSIndexPath *indexPath in self.sizeCache.allKeys) {
        if (indexPath.section == section) {
            [needMove addObject:indexPath];
        }
        if (indexPath.section == newSection) {
            [needMoveNew addObject:indexPath];
        }
    }
    NSMutableDictionary<NSIndexPath*, NSValue*> *newSizeCache = [self.sizeCache mutableCopy];
    for (NSIndexPath *indexPath in newSizeCache.allKeys) {
        if (indexPath.section == section) {
            [newSizeCache removeObjectForKey:indexPath];
        }
        if (indexPath.section == newSection) {
            [newSizeCache removeObjectForKey:indexPath];
        }
    }
    for (NSIndexPath *indexPath in needMove) {
        NSValue *value = [self.sizeCache objectForKey:indexPath];
        [newSizeCache setObject:value forKey:[NSIndexPath indexPathForRow:indexPath.row inSection:newSection]];
    }
    for (NSIndexPath *indexPath in needMoveNew) {
        NSValue *value = [self.sizeCache objectForKey:indexPath];
        [newSizeCache setObject:value forKey:[NSIndexPath indexPathForRow:indexPath.row inSection:section]];
    }
    self.sizeCache = newSizeCache;
    [super moveSection:section toSection:newSection];
}

- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths {
    [self.sizeCache removeObjectsForKeys:indexPaths];
    [self reloadItemsAtIndexPaths:indexPaths];
}

- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths {
    [self.sizeCache removeObjectsForKeys:indexPaths];
    [self deleteItemsAtIndexPaths:indexPaths];
}

- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath
                toIndexPath:(NSIndexPath *)newIndexPath {
    NSValue *tempValue = [self.sizeCache objectForKey:indexPath];
    [self.sizeCache setObject:[self.sizeCache objectForKey:newIndexPath] forKey:indexPath];
    [self.sizeCache setObject:tempValue forKey:newIndexPath];
    [self moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
}

#pragma mark - public

- (CGSize)sizeForCellWithIdentifier:(NSString *)identifier
                          indexPath:(NSIndexPath *)indexPath
                      configuration:(void (^)(__kindof YNSelfSizingCollectionViewCell *))configuration{
    if ([self.sizeCache.allKeys containsObject:indexPath]) {
        return [[self.sizeCache objectForKey:indexPath] CGSizeValue];
    }
    
    // has no size chche
    CGSize size = CGSizeZero;
    if ([[self.fixWidthAndHeightCellValues allKeys] containsObject:identifier]) {
        NSValue *sizeValue = [self.fixWidthAndHeightCellValues objectForKey:identifier];
        NSAssert(sizeValue, @"no sizeValue");
        size = [sizeValue CGSizeValue];
    }else{
        YNSelfSizingCollectionViewCell *cell = [self.templeCells objectForKey:identifier];
        NSAssert(cell, @"cell is nil");
        configuration(cell);
        switch ([cell.class layoutType]) {
            case YNSelfSizingCollectionViewCellLayoutTypeFrameLayout:{
                [cell.contentView setNeedsLayout];
                [cell.contentView layoutIfNeeded];
                [cell sizeToFit];
                size = cell.frame.size;
                break;
            }
            case YNSelfSizingCollectionViewCellLayoutTypeAutoLayout:{
                [cell.contentView setNeedsUpdateConstraints];
                [cell.contentView setNeedsLayout];
                [cell.contentView updateConstraintsIfNeeded];
                [cell.contentView layoutIfNeeded];
                size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
                break;
            }
            default:
                break;
        }
    }
    size = CGSizeMake(YNSelfSizingRoundPixelValue(size.width), YNSelfSizingRoundPixelValue(size.height));
    NSValue *sizeValue = [NSValue valueWithCGSize:size];
    [self.sizeCache setObject:sizeValue forKey:indexPath];
    return size;
}

@end
