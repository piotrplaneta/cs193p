//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Piotr Planeta on 22.07.2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void) pushOperand:(double)digit;
- (double) performOperation:(NSString *)operation;
- (void) clearStack;

@end
