//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Piotr Planeta on 22.07.2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()

@property (nonatomic, strong) NSMutableArray *operandStack;

@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *)operandStack
{
    if (_operandStack == nil) _operandStack = [[NSMutableArray alloc] init];
    return _operandStack;
}

- (double) popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

- (void) pushOperand:(double)operand 
{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double) performOperation:(NSString *)operation 
{
    double result = 0;
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    } else if ([operation isEqualToString:@"-"]) {
        double d1 = [self popOperand];
        double d2 = [self popOperand];
        result = d2 - d1;
    } else if ([operation isEqualToString:@"*"]) {
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"/"]) {
        double d1 = [self popOperand];
        double d2 = [self popOperand];
        if (d1 == 0) {
            result = 0;
        } else {
            result = d2 / d1;
        }
        
    } else if ([operation isEqualToString:@"sin"]) {
        result = sin([self popOperand]);
    } else if ([operation isEqualToString:@"cos"]) {
        result = cos([self popOperand]);
    } else if ([operation isEqualToString:@"√"]) {
        result = sqrt([self popOperand]);
    } else if ([operation isEqualToString:@"π"]) {
        result = M_PI;
    } else if ([operation isEqualToString:@"+/-"]) {
        result = -([self popOperand]);
    }
    [self pushOperand:result];
    return result;
}

- (void) clearStack {
    [self.operandStack removeAllObjects];
}
@end
