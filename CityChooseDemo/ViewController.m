//
//  ViewController.m
//  XiaoDongDemo2
//
//  Created by Story5 on 15/12/16.
//  Copyright © 2015年 Story5. All rights reserved.
//

#import "ViewController.h"
#import "ScaleHelper.h"

#import "HeaderView.h"
#import "RecentCityCell.h"
#import "CityCell.h"
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,CityCellDelegate>
{
    NSMutableArray *_recentCitiesArray;
    
    NSDictionary *_citiesDictionary;
    
    NSMutableArray *_collectionViewDataArray;
    UICollectionView *_collectionView;
    
    UILabel *_headerLabel;
}

@end

@implementation ViewController
- (void)dealloc
{
    if (_recentCitiesArray) {
        [_recentCitiesArray removeAllObjects];
        [_recentCitiesArray release];
        _recentCitiesArray = nil;
    }
    
    if (_citiesDictionary) {
        [_citiesDictionary release];
        _citiesDictionary = nil;
    }
    
    if (_collectionViewDataArray) {
        [_collectionViewDataArray removeAllObjects];
        [_collectionViewDataArray release];
        _collectionViewDataArray = nil;
    }
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //  1.定位城市
    NSDictionary *locationCity = @{@"定位城市":@"建德县"};
    
    
    //  2.最近访问
    _recentCitiesArray = [[NSMutableArray alloc] initWithCapacity:2];
    [_recentCitiesArray addObject:@"杭州市"];
    [_recentCitiesArray addObject:@"桐庐县"];
    [_recentCitiesArray addObject:@"富阳市"];
    NSDictionary *recentVisit = @{@"最近访问":_recentCitiesArray};
    
    //  3.其他分战
    _citiesDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CityPlist" ofType:@"plist"]];
    NSDictionary *otherSection = @{@"其他分站":_citiesDictionary};
    
    // UICollectionView 数据
    _collectionViewDataArray = [[NSMutableArray alloc] initWithObjects:locationCity,recentVisit,otherSection, nil];
//    [_collectionViewDataArray removeLastObject];
    
    
    
    [ScaleHelper initScale];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - touch event 
- (void)backButtonClick:(UIButton *)aSender
{
    NSLog(@"back button click");
//    [_collectionView reloadData];
}

#pragma mark - CityCellDelegate
- (void)onTouchCity:(NSString *)aCityName
{
    NSLog(@"%@",aCityName);
    if (![_recentCitiesArray containsObject:aCityName]) {
        [_recentCitiesArray addObject:aCityName];
    }
    
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:1];
    [_collectionView reloadSections:sections];
}

#pragma mark - UICollectionViewDataSource
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _collectionViewDataArray[indexPath.section];
    
    if (indexPath.section == 0) {
        
        RecentCityCell *locationCityCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"locationCity" forIndexPath:indexPath];
        locationCityCell.textLabel.text = dic.allValues.firstObject;

        return locationCityCell;
        
    } else if (indexPath.section == 1) {
        
        RecentCityCell *recentCitiesCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"recentCities" forIndexPath:indexPath];
        recentCitiesCell.textLabel.text = _recentCitiesArray[indexPath.row];

        return recentCitiesCell;
        
    } else if (indexPath.section == 2) {
        
        CityCell *cityCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"city" forIndexPath:indexPath];
        [cityCell setCityDictionary:_citiesDictionary];
        cityCell.delegate = self;
        
        return cityCell;
    }
    
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 1){
        return _recentCitiesArray.count;
    }
    
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _collectionViewDataArray.count;
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _collectionViewDataArray[indexPath.section];
    
    if (kind == UICollectionElementKindSectionHeader){
        
        HeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        headerView.textLabel.text = dic.allKeys.firstObject;
        
        return headerView;
        
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegate
// Methods for notification of selection/deselection and highlight/unhighlight events.
// The sequence of calls leading to selection from a user touch is:
//
// (when the touch begins)
// 1. -collectionView:shouldHighlightItemAtIndexPath:
// 2. -collectionView:didHighlightItemAtIndexPath:
//
// (when the touch lifts)
// 3. -collectionView:shouldSelectItemAtIndexPath: or -collectionView:shouldDeselectItemAtIndexPath:
// 4. -collectionView:didSelectItemAtIndexPath: or -collectionView:didDeselectItemAtIndexPath:
// 5. -collectionView:didUnhighlightItemAtIndexPath:
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//
//// called when the user taps on an already-selected item in multi-select mode
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0)
//{
//    
//}
//- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0)
//{
//    
//}
//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//
//// These methods provide support for copy/paste actions on cells.
//// All three should be implemented if any are.
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
//{
//    
//}
//- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
//{
//    
//}
//
//// support for custom transition layout
//- (nonnull UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout
//{
//    
//}
//
//// Focus
//- (BOOL)collectionView:(UICollectionView *)collectionView canFocusItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0)
//{
//    
//}
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context NS_AVAILABLE_IOS(9_0)
//{
//    
//}
//- (void)collectionView:(UICollectionView *)collectionView didUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator NS_AVAILABLE_IOS(9_0)
//{
//    
//}
//- (nullable NSIndexPath *)indexPathForPreferredFocusedViewInCollectionView:(UICollectionView *)collectionView NS_AVAILABLE_IOS(9_0)
//{
//    
//}
//
//- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath NS_AVAILABLE_IOS(9_0)
//{
//    
//}
//
//// customize the content offset to be applied during transition or update animations
//- (CGPoint)collectionView:(UICollectionView *)collectionView targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset NS_AVAILABLE_IOS(9_0)
//{
//    
//}

#pragma mark - UICollectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//
//}


/** 每个头标题大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.frame.size.width, ScalePx(78));
}



/** 每个cell的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 2) {
        return CGSizeMake(collectionView.frame.size.width, ScalePx(99) * _citiesDictionary.count);
    } else {
        return ScaleCGSizeMake(197, 75);
    }
    
    return CGSizeZero;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 2) {
    
        return UIEdgeInsetsZero;
        
    } else {
        CGFloat top = ScalePx(22.5);
        CGFloat left = ScalePx(31);
        CGFloat bottom = ScalePx(22.5);
        CGFloat right = ScalePx(31);
        return UIEdgeInsetsMake(top, left, bottom, right);
    }
    
    return UIEdgeInsetsZero;
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    
//}
//


#pragma mark - private methods
- (void)initUI
{
    UILabel *currentCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
    currentCityLabel.backgroundColor = [UIColor whiteColor];
    currentCityLabel.textAlignment = NSTextAlignmentCenter;
    currentCityLabel.text = @"当前城市:杭州";
    [self.view addSubview:currentCityLabel];
    [currentCityLabel release];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 30, 20, 20);
    [backButton setTitle:@"X" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    float originY = currentCityLabel.frame.origin.y + currentCityLabel.frame.size.height;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView release];
    
    
    //注册cell
    [_collectionView registerClass:[HeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    [_collectionView registerClass:[RecentCityCell class] forCellWithReuseIdentifier:@"locationCity"];
    
    [_collectionView registerClass:[RecentCityCell class] forCellWithReuseIdentifier:@"recentCities"];
    
    [_collectionView registerClass:[CityCell class] forCellWithReuseIdentifier:@"city"];
    
}

@end
