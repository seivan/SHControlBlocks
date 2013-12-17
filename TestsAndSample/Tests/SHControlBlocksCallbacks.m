//
//  ExampleTests.m
//  ExampleTests
//
//  Created by Seivan Heidari on 7/27/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//


#import "SHControlBlocksSuper.h"

@interface SHControlBlocksCallbacks : SHControlBlocksSuper
@property(nonatomic,assign) NSInteger isAsserted;
@end




@implementation SHControlBlocksCallbacks

#pragma mark - Add block
-(void)testSH_addControlEvents_withBlock; {
  __block BOOL didAssert = NO;
  [self.button SH_addControlEvents:UIControlEventTouchUpInside withBlock:^(UIControl *sender) {
    XCTAssertEqualObjects(self.button, sender);
    didAssert = YES;
  }];
  
  self.block = [self.button SH_blocksForControlEvents:UIControlEventTouchUpInside].allObjects.firstObject;
  self.block(self.button);
  XCTAssertTrue(didAssert);
  
  
}

-(void)testSH_addControlEventTouchUpInsideWithBlock_theBlock; {
  __block BOOL didAssert = NO;
  [self.button SH_addControlEventTouchUpInsideWithBlock:^(UIControl *sender) {
    XCTAssertEqualObjects(self.button, sender);
    didAssert = YES;
  }];
  
  self.block = [self.button SH_blocksForControlEvents:UIControlEventTouchUpInside].allObjects.firstObject;
  self.block(self.button);

  XCTAssertTrue(didAssert);
  
}


#pragma mark - Helpers
-(void)testSH_blocksForControlEvents; {
  __block BOOL didAssertFirstBlock  = NO;
  __block BOOL didAssertSecondBlock = NO;
  UIControlEvents event = UIControlEventTouchUpInside;
  [self.button SH_addControlEventTouchUpInsideWithBlock:^(UIControl *sender) {
    XCTAssertEqualObjects(self.button, sender);
    didAssertFirstBlock = YES;
  }];
  [self.button SH_addControlEvents:event withBlock:^(UIControl *sender) {
    XCTAssertEqualObjects(self.button, sender);
    didAssertSecondBlock = YES;
  }];
  NSArray * blocks = [[self.button SH_blocksForControlEvents:event] allObjects];
  
  SHControlEventBlock firstBlock = blocks.firstObject;
  firstBlock(self.button);

  SHControlEventBlock secondBlock = blocks.lastObject;
  secondBlock(self.button);
  
  XCTAssertTrue(didAssertFirstBlock);
  XCTAssertTrue(didAssertSecondBlock);
    
}

-(void)testSH_controlEventsForBlock; {
  __block BOOL didAssertFirstBlock  = NO;
  __block BOOL didAssertSecondBlock = NO;
  UIControlEvents event = UIControlEventTouchDragExit;
  SHControlEventBlock firstBlock = ^(UIControl *sender) {
    XCTAssertEqualObjects(self.button, sender);
    didAssertFirstBlock = YES;

  };
  [self.button SH_addControlEventTouchUpInsideWithBlock:firstBlock];
  
  SHControlEventBlock secondBlock = ^(UIControl *sender) {
    XCTAssertEqualObjects(self.button, sender);
    didAssertSecondBlock = YES;

  };
  
  [self.button SH_addControlEvents:event withBlock:secondBlock];
  
  UIControlEvents firstEvent  = ((NSNumber *)[self.button
                                                SH_controlEventsForBlock:firstBlock].allObjects.firstObject).unsignedIntegerValue;
  UIControlEvents secondEvent = ((NSNumber *)[self.button
                                                SH_controlEventsForBlock:secondBlock].allObjects.firstObject).unsignedIntegerValue;
  
  [self.button sendActionsForControlEvents:firstEvent];
  [self.button sendActionsForControlEvents:secondEvent];
  
  XCTAssertTrue(didAssertFirstBlock);
  XCTAssertTrue(didAssertSecondBlock);

}


@end
