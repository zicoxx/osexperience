#import <UIKit/UIKit.h>
#import "OSThumbnailWrapper.h"
#import "OSPaneThumbnail.h"
#import "../OSPaneModel.h"
#import "../OSPane.h"
#import "../explorer/CGPointExtension.h"
#import "OSAddDesktopButton.h"


#define thumbnailMarginSize 20
#define wrapperCenter 20


@class OSThumbnailWrapper;

@interface OSThumbnailView : UIView <OSAddDesktopButtonDelegate>{
	OSThumbnailWrapper *_wrapperView;
	OSAddDesktopButton *_addDesktopButton;
	BOOL _shouldLayoutSubviews;
}

@property (nonatomic, retain) OSThumbnailWrapper *wrapperView;
@property (nonatomic, retain) OSAddDesktopButton *addDesktopButton;
@property (nonatomic, readwrite) BOOL shouldLayoutSubviews;

+ (id)sharedInstance;

- (BOOL)isPortrait;
- (void)addPane:(OSPane*)pane;
- (void)alignSubviews;
- (BOOL)isPortrait:(UIInterfaceOrientation)orientation;
- (void)removePane:(OSPane*)pane animated:(BOOL)animated;
- (void)updateSelectedThumbnail;
- (void)closeAllCloseboxesAnimated:(BOOL)animated;
- (void)updatePressedThumbnails;
- (OSPaneThumbnail*)thumbnailForPane:(OSPane*)pane;

@end