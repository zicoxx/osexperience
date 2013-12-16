#import "OSFileGridViewController.h"
#import "OSFileViewController.h"
#import "OSFileGridTile.h"
#import "OSSelectionDragView.h"

#define tilesPerColumn self.bounds.size.height / self.gridSpacing.y
#define tilesPerRow self.bounds.size.width / self.gridSpacing.x

#define CGRectFromCGPoints(p1, p2) CGRectMake(MIN(p1.x, p2.x), MIN(p1.y, p2.y), fabs(p1.x - p2.x), fabs(p1.y - p2.y))


@implementation OSFileGridViewController
@synthesize type = _type;

- (id)init{
	if(![super init])
		return nil;

	self.type = OSFileGridViewTypeWindowed;
	self.iconSize = CGSizeMake(72, 72);
	self.gridSpacing = 20;

	return self;
}

- (void)loadView{
	self.view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	UIPanGestureRecognizer *selectGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSelectGesture:)];
	selectGesture.maximumNumberOfTouches = 1;
	[self.view addGestureRecognizer:selectGesture];
	[selectGesture release];

	self.loaded = true;
}

- (void)layoutView{
	for(UIView *view in self.view.subviews)
		[view removeFromSuperview];

	int ix = 0;
	int iy = 0;

	NSError *error = nil;

	for(NSURL *url in [[NSFileManager defaultManager] contentsOfDirectoryAtURL:self.path includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error]){
		OSFileGridTile *tile = [self tileForFileAtPath:url];

		if(tile.frame.size.height * (iy + 1) > self.view.bounds.size.height){
			iy = 0;
			ix++;
		}

		CGPoint origin = CGPointMake(self.view.bounds.size.width - (tile.bounds.size.width * (ix + 1)), 0 + (tile.bounds.size.height * iy));

		CGRect frame = tile.frame;
		frame.origin = origin;
		tile.frame = frame;

		[tile setURL:url];

		[self.view addSubview:tile];

		iy++;
	}
}

-(void)handleSelectGesture:(UIPanGestureRecognizer *)gesture{
    if([gesture state] == UIGestureRecognizerStateChanged){

		[self.dragView setFrame:CGRectFromCGPoints(self.dragView.dragStartPoint, [gesture locationInView:self.view])];

	}else if([gesture state] == UIGestureRecognizerStateBegan){

		self.dragView = [[OSSelectionDragView alloc] init];
		[self.view addSubview:self.dragView];
        [self.view bringSubviewToFront:self.dragView];
        self.dragView.hidden = false;
        self.dragView.dragStartPoint = [gesture locationInView:self.view];
        [self.dragView release];

	}else if([gesture state] == UIGestureRecognizerStateEnded || [gesture state] == UIGestureRecognizerStateCancelled){

		OSSelectionDragView *dragView = self.dragView;
		[dragView retain];

		self.dragView = nil;

        [UIView animateWithDuration:0.25 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^{
			dragView.alpha = 0;
        }completion:^(BOOL finished){
        	[dragView release];
			[dragView removeFromSuperview];
        }];

    }
}

- (OSFileGridTile *)tileForFileAtPath:(NSURL*)path{
	OSFileGridTile *tile = [[OSFileGridTile alloc] initWithIconSize:self.iconSize gridSpacing:self.gridSpacing];

	UIDocumentInteractionController *documentController = [UIDocumentInteractionController interactionControllerWithURL:path];
	[tile setIcon:[[documentController icons] objectAtIndex:0]];

	return [tile autorelease];
}

@end