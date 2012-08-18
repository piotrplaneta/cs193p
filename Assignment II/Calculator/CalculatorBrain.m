//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Piotr Płaneta on 22.07.2012.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()

@property (nonatomic, strong) NSMutableArray *programStack;

@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}


+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    int i;
    for (i = 0; i < stack.count; i++) {
        id variable = [stack objectAtIndex:i];
        if (![variable isKindOfClass:[NSNumber class]] && ![self isOperation:variable]) {
            if ([variableValues objectForKey:variable] && [[variableValues objectForKey:variable] isKindOfClass:[NSNumber class]]) {
                [stack replaceObjectAtIndex:i withObject:[variableValues objectForKey:variable]];
            }
            else {
                [stack replaceObjectAtIndex:i withObject:@0];
            }
        }
    }
    
    return [self popOperandOffStack:stack];
}

+ (BOOL)isOperation:(id)operation
{
    NSSet *operations = [[NSSet alloc] initWithObjects:@"+", @"-", @"*", @"/", @"sin", @"cos", @"√", @"π", @"+/-", nil];
    if ([operations containsObject:operation]) {
        return TRUE;
    }
    else {
        return FALSE;
    }
}

+ (double)popOperandOffStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        }
        else if ([operation isEqualToString:@"-"]) {
            double d1 = [self popOperandOffStack:stack];
            double d2 = [self popOperandOffStack:stack];
            result = d2 - d1;
        }
        else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        }
        else if ([operation isEqualToString:@"/"]) {
            double d1 = [self popOperandOffStack:stack];
            double d2 = [self popOperandOffStack:stack];
            result = d2 / d1;
        }
        else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffStack:stack]);
        }
        else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffStack:stack]);
        }
        else if ([operation isEqualToString:@"√"]) {
            result = sqrt([self popOperandOffStack:stack]);
        }
        else if ([operation isEqualToString:@"π"]) {
            result = M_PI;
        }
        else if ([operation isEqualToString:@"+/-"]) {
            result = -([self popOperandOffStack:stack]);
        }
    }
    
    return result;
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSString *description = [[NSString alloc] init];
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    while ([stack lastObject]) {
        if ([description isEqualToString:@""]) {
            description = [self suppressParentheses:[self descriptionOfTopOfStack:stack]];
        }
        else {
            description = [self suppressParentheses:[NSString stringWithFormat:@"%@, %@", [self descriptionOfTopOfStack:stack], description]];
        }

    }

    return description;
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack
{
    NSString *description = [[NSString alloc] init];
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if (!topOfStack) {
        description = @"0";
    }
    else if([topOfStack isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)topOfStack;
        description = [NSString stringWithFormat:@"%g", [number doubleValue]];
    }
    else if([topOfStack isKindOfClass:[NSString class]]) {
        NSString *variable = (NSString *)topOfStack;
        if (![self isOperation:variable]) {
            description = [NSString stringWithFormat:@"%@", variable];
        }
        else {
            NSString *operation = variable;
            if ([self operationOperandsCount:operation] == 0) {
                description = [NSString stringWithFormat:@"%@", operation];
            }
            else if ([self operationOperandsCount:operation] == 1) {
                if ([operation isEqualToString:@"+/-"]) {
                    description = [NSString stringWithFormat:@"%@(%@)", @"-", [self suppressParentheses:[self descriptionOfTopOfStack:stack]]];
                }
                else {
                    description = [NSString stringWithFormat:@"%@(%@)", operation, [self suppressParentheses:[self descriptionOfTopOfStack:stack]]];
                }

            }
            else {
                NSString *operand2 = [self descriptionOfTopOfStack:stack];
                NSString *operand1 = [self descriptionOfTopOfStack:stack];
                if ([operation isEqualToString:@"*"] || [operation isEqualToString:@"/"]) {
                    description = [NSString stringWithFormat:@"%@ %@ %@", operand1, operation, operand2];
                }
                else {
                    description = [NSString stringWithFormat:@"(%@ %@ %@)", operand1, operation, operand2];
                }
                
            }
        }
    }
    return description;
}

+ (int)operationOperandsCount:(NSString *)operation
{
    NSSet *operationsWithNoOperand = [[NSSet alloc] initWithObjects:@"π", nil];
    NSSet *operationsWithOneOperand = [[NSSet alloc] initWithObjects:@"sin", @"cos", @"√", @"+/-", nil];
    
    if ([operationsWithNoOperand containsObject:operation]) {
        return 0;
    }
    else if ([operationsWithOneOperand containsObject:operation]) {
        return 1;
    }
    else {
        return 2;
    }
}

+ (NSString *)suppressParentheses:(NSString *)description
{
    if ([[description substringToIndex:1] isEqualToString:@"("] && [[description substringFromIndex:(description.length-1)]isEqualToString:@")"]) {
        return [description substringWithRange:NSMakeRange(1, description.length-2)];
    }
    else {
        return description;
    }
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSMutableSet* variables = [[NSMutableSet alloc] init];
    if ([program isKindOfClass:[NSArray class]]) {
        NSArray *stack = (NSArray *)program;
        for (id element in stack) {
            if (![element isKindOfClass:[NSNumber class]] && ![self isOperation:element]) {
                if (![variables containsObject:element]) {
                    [variables addObject:element];
                }
            }
        }
    }
    return [variables copy];
}


- (void)pushOperand:(double)operand 
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
}

- (void)pushVariable:(NSString *)variable
{
    [self.programStack addObject:variable];
}

- (NSString *)descriptionOfCurrentProgram
{
    return [CalculatorBrain descriptionOfProgram:self.program];
}

- (void)removeItemFromTopOfStack
{
    if ([self.programStack lastObject])
        [self.programStack removeLastObject];
}

- (void)clearStack {
    [self.programStack removeAllObjects];
}
@end
