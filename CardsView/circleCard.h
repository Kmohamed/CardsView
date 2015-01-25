//
//  circleCard.h
//  CircleTableView
//
//  Created by khaled el morabea on 11/5/14.
//  Copyright (c) 2014 Ibtikar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface circleCard : NSObject
@property (nonatomic) CGFloat width_Angle;
@property (nonatomic) CGFloat large_Raduis;
@property (nonatomic) CGFloat small_Raduis;
@property (nonatomic) CGFloat start_angle;
@property (nonatomic) BOOL isRotating;
@property (nonatomic) CGFloat nextTarget;
@property (nonatomic,strong) NSString *cardName;
@property (nonatomic) NSInteger cardIndex;
@property (nonatomic) BOOL isLeft;

-(id)initWithStartAngle:(CGFloat)startAngle andWidth:(CGFloat)width andLargeRaduis:(CGFloat)largeRaduis andSmallRaduis:(CGFloat)smallRaduis andCardName:(NSString*)cardName andCardIndex:(NSInteger)index;
@end
