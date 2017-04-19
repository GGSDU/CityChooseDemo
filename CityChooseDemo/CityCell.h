//
//  CityCell.h
//  XiaoDongDemo2
//
//  Created by Story5 on 15/12/16.
//  Copyright © 2015年 Story5. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityCellDelegate <NSObject>

- (void)onTouchCity:(NSString *)aCityName;

@end

@interface CityCell : UICollectionViewCell

@property (nonatomic,assign) id<CityCellDelegate>delegate;

- (instancetype)initWithCityDictionary:(NSDictionary *)aCityDictionary;

- (void)setCityDictionary:(NSDictionary *)aCityDictionary;
- (void)initUI;

@end
