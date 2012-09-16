//
//  GraphView.h
//  Calculator
//
//  Created by Piotr Płaneta on 16.09.2012.
//
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphViewDataSource

- (float)resultOfProgramForXValue:(float)x forGraphView:(GraphView *)sender;
- (NSString *)descriptionOfProgram:(id)program forGraphView:(GraphView *)sender;

@end

@interface GraphView : UIView

@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;

- (void) pinch:(UIPinchGestureRecognizer *)gesture;
- (void) pan:(UIPanGestureRecognizer *)gesture;
- (void) tap:(UIPanGestureRecognizer *)gesture;

@end
