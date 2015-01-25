//
//  CardData.h
//  CircleTableView
//
//  Created by khaled el morabea on 11/11/14.
//  Copyright (c) 2014 Ibtikar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CardData : NSObject
@property (nonatomic,strong) NSString *cardName;
@property (nonatomic,strong) UIImage *cardImage;
@property (nonatomic) BOOL isSelected;

@end
