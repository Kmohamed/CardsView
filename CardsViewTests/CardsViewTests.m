//
//  CardsViewTests.m
//  CardsViewTests
//
//  Created by khaled El Morabeaa on 1/25/15.
//  Copyright (c) 2015 Brightunit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CardData.h"
#import "circleCard.h"

// ---------------------------------------------------------------------------
#pragma mark - CardData Tests
// ---------------------------------------------------------------------------

@interface CardDataTests : XCTestCase
@end

@implementation CardDataTests

- (void)test_initWithNameAndImage_setsCardName {
    CardData *card = [[CardData alloc] initWithName:@"Home" andImage:nil];
    XCTAssertEqualObjects(card.cardName, @"Home");
}

- (void)test_initWithNameAndImage_defaultsIsSelectedToNO {
    CardData *card = [[CardData alloc] initWithName:@"Settings" andImage:nil];
    XCTAssertFalse(card.isSelected);
}

- (void)test_resetSelection_clearsIsSelected {
    CardData *card = [[CardData alloc] initWithName:@"Profile" andImage:nil];
    card.isSelected = YES;
    [card resetSelection];
    XCTAssertFalse(card.isSelected);
}

- (void)test_toDictionary_containsCardName {
    CardData *card = [[CardData alloc] initWithName:@"Messages" andImage:nil];
    NSDictionary *dict = [card toDictionary];
    XCTAssertEqualObjects(dict[@"cardName"], @"Messages");
}

- (void)test_toDictionary_reflectsIsSelectedState {
    CardData *card = [[CardData alloc] initWithName:@"Notifications" andImage:nil];
    card.isSelected = YES;
    NSDictionary *dict = [card toDictionary];
    XCTAssertEqualObjects(dict[@"isSelected"], @YES);
}

- (void)test_toDictionary_usesEmptyStringWhenNameIsNil {
    CardData *card = [[CardData alloc] init];
    NSDictionary *dict = [card toDictionary];
    XCTAssertEqualObjects(dict[@"cardName"], @"");
}

@end

// ---------------------------------------------------------------------------
#pragma mark - circleCard Tests
// ---------------------------------------------------------------------------

@interface CircleCardTests : XCTestCase
@property (nonatomic, strong) circleCard *card;
@end

@implementation CircleCardTests

- (void)setUp {
    [super setUp];
    // Card starting at 100°, spanning 40°, radii 170/80, index 0
    self.card = [[circleCard alloc] initWithStartAngle:100.0
                                              andWidth:40.0
                                        andLargeRaduis:170.0
                                        andSmallRaduis:80.0
                                           andCardName:@"TestCard"
                                         andCardIndex:0];
}

- (void)tearDown {
    self.card = nil;
    [super tearDown];
}

- (void)test_init_setsStartAngle {
    XCTAssertEqual(self.card.start_angle, 100.0);
}

- (void)test_init_setsWidthAngle {
    XCTAssertEqual(self.card.width_Angle, 40.0);
}

- (void)test_init_setsLargeRadius {
    XCTAssertEqual(self.card.large_Raduis, 170.0);
}

- (void)test_init_setsSmallRadius {
    XCTAssertEqual(self.card.small_Raduis, 80.0);
}

- (void)test_init_setsCardName {
    XCTAssertEqualObjects(self.card.cardName, @"TestCard");
}

- (void)test_init_setsCardIndex {
    XCTAssertEqual(self.card.cardIndex, 0);
}

- (void)test_centerAngle_isStartPlusHalfWidth {
    // start=100, width=40 → center=120
    XCTAssertEqual([self.card centerAngle], 120.0);
}

- (void)test_endAngle_isStartPlusWidth {
    // start=100, width=40 → end=140
    XCTAssertEqual([self.card endAngle], 140.0);
}

- (void)test_containsAngle_returnsTrueForAngleAtStart {
    XCTAssertTrue([self.card containsAngle:100.0]);
}

- (void)test_containsAngle_returnsTrueForAngleAtCenter {
    XCTAssertTrue([self.card containsAngle:120.0]);
}

- (void)test_containsAngle_returnsTrueForAngleAtEnd {
    XCTAssertTrue([self.card containsAngle:140.0]);
}

- (void)test_containsAngle_returnsFalseForAngleBelowStart {
    XCTAssertFalse([self.card containsAngle:99.9]);
}

- (void)test_containsAngle_returnsFalseForAngleAboveEnd {
    XCTAssertFalse([self.card containsAngle:140.1]);
}

@end
