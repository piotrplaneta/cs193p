//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Piotr Planeta on 22.07.2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringNumber;
@property (nonatomic, strong) CalculatorBrain *brain;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize userInput = _userInput;
@synthesize userIsInTheMiddleOfEnteringNumber = _userIsInTheMiddleOfEnteringNumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    if ([digit isEqualToString:@"0"]) {
        if ([self.display.text isEqualToString:@"0"]) {
            return;
        }
    }
    if (self.userIsInTheMiddleOfEnteringNumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringNumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringNumber) {
        [self enterPressed];
    }
    self.userInput.text = [NSString stringWithFormat:@"%@ %@ =", self.userInput.text, sender.currentTitle];
    double result = [self.brain performOperation:sender.currentTitle];
    NSString* resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userInput.text = [NSString stringWithFormat:@"%@ %@", self.userInput.text, self.display.text];
    self.userIsInTheMiddleOfEnteringNumber = NO;
}

- (IBAction)decimalPointPressed {
    if (!self.userIsInTheMiddleOfEnteringNumber) {
        self.display.text = @"0.";
        self.userIsInTheMiddleOfEnteringNumber = YES;
        return;
    }
    NSRange positionOfDecimalPoint = [self.display.text rangeOfString:@"."];
    if (positionOfDecimalPoint.location == NSNotFound) {
        self.userIsInTheMiddleOfEnteringNumber = YES;
        NSString* decimalPoint = @".";
        self.display.text = [self.display.text stringByAppendingString:decimalPoint];
    }
}

- (IBAction)clearPressed {
    self.display.text = @"0";
    self.userInput.text = @"";
    self.userIsInTheMiddleOfEnteringNumber = NO;
    [self.brain clearStack];
}

- (IBAction)backspacePressed {
    if (self.display.text.length == 1) {
        self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringNumber = NO;
    } else {
        self.display.text = [self.display.text substringToIndex:(self.display.text.length - 1)];
    }
}

- (IBAction)plusMinusPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringNumber) {
        double currentNumber = [self.display.text doubleValue];
        currentNumber = -currentNumber;
        self.display.text = [NSString stringWithFormat:@"%g", currentNumber];
    } else {
        [self operationPressed:sender];
    }
}

- (void)viewDidUnload {
    [self setBrain:nil];
    
    [self setDisplay:nil];
    [self setUserInput:nil];
    [super viewDidUnload];
}
@end
