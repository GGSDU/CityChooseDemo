//
//  CityCell.m
//  ;
//
//  Created by Story5 on 15/12/16.
//  Copyright © 2015年 Story5. All rights reserved.
//

#import "CityCell.h"
#import "ScaleHelper.h"
@interface CityCell ()<UITableViewDataSource,UITableViewDelegate>
{
    NSDictionary *_cityDictionary;
    
    NSArray *_provinceArray;
    UITableView *_provinceTableView;
    
    NSMutableArray *_cityArray;
    UITableView *_cityTableView;
}

@end

@implementation CityCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
        
    }
    return self;
}

- (instancetype)initWithCityDictionary:(NSDictionary *)aCityDictionary
{
    self = [super init];
    if (self) {
        
        [self initUI];
        
    }
    return self;
}

- (void)dealloc
{
    if (_cityDictionary) {
        [_cityDictionary release];
        _cityDictionary = nil;
    }
    
    if (_provinceArray) {
        [_provinceArray release];
        _provinceArray = nil;
    }
    
    if (_cityArray) {
        [_cityArray removeAllObjects];
        [_cityArray release];
        _cityArray = nil;
    }
    [super dealloc];
}

#pragma mark - public methods
- (void)setCityDictionary:(NSDictionary *)aCityDictionary
{
    _cityDictionary = [aCityDictionary retain];
    
    _provinceArray = [[NSArray alloc] initWithArray:_cityDictionary.allKeys];
    
    _cityArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    [self reloadData];
    [self selectFirstProvince];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        
        return _provinceArray.count;
        
    } else if (tableView.tag == 2) {
        
        return _cityArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        
        UITableViewCell *provinceCell = [tableView dequeueReusableCellWithIdentifier:@"province"];
        if (provinceCell == nil) {
            provinceCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"province"];
            provinceCell.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
        }
        provinceCell.textLabel.text = _provinceArray[indexPath.row];
        
        return provinceCell;
        
    } else if (tableView.tag == 2) {
        
        UITableViewCell *cityCell = [tableView dequeueReusableCellWithIdentifier:@"city"];
        if (cityCell == nil) {
            cityCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"city"];
        }
        cityCell.textLabel.text = _cityArray[indexPath.row];
        
        return cityCell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScalePx(99);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        
        if (_cityArray.count > 0) {
            [_cityArray removeAllObjects];
        }
        NSString *key = _provinceArray[indexPath.row];
        [_cityArray addObjectsFromArray:_cityDictionary[key]];
        
        
        //点击了省份,更新城市
        [_cityTableView reloadData];
    } else if (tableView.tag == 2){
        
        NSString *cityName = _cityArray[indexPath.row];
        if (_delegate && [_delegate respondsToSelector:@selector(onTouchCity:)]) {
            
            [_delegate onTouchCity:cityName];
        }

    }
}

#pragma mark - private methods
- (void)initUI
{
    _provinceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScalePx(312), self.contentView.frame.size.height) style:UITableViewStylePlain];
    _provinceTableView.tag = 1;
    _provinceTableView.dataSource = self;
    _provinceTableView.delegate = self;
    [self.contentView addSubview:_provinceTableView];
    [_provinceTableView release];
    
    
    float originX = _provinceTableView.frame.size.width;
    _cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(originX, 0, self.contentView.frame.size.width - originX, _provinceTableView.frame.size.height) style:UITableViewStylePlain];
    _cityTableView.tag = 2;
    _cityTableView.dataSource = self;
    _cityTableView.delegate = self;
    [self.contentView addSubview:_cityTableView];
    [_cityTableView release];
}

- (void)reloadData
{
    [_provinceTableView reloadData];
    [_cityTableView reloadData];
}

- (void)selectFirstProvince
{
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_provinceTableView selectRowAtIndexPath:firstIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self tableView:_provinceTableView didSelectRowAtIndexPath:firstIndexPath];
}

@end
